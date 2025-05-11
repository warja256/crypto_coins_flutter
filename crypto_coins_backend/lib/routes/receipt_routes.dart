//TODO Создание чека (Receipt) после транзакции
import 'dart:convert';
import 'dart:io';
import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/receipt.dart';
import 'package:shelf/shelf.dart';

Future<Response> createReceipt(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> receiptMap = jsonDecode(payload);
    final receipt = Receipt.fromJson(receiptMap);

    await connection.execute(
      'INSERT INTO "Receipt"(transaction_id, receipt_id, user_id, type, currency, email, date, file_path) VALUES(@transaction_id, @receipt_id, @user_id, @type, @currency, @email, @date, @file_path)',
      parameters: {
        'receipt_id': receipt.receiptId,
        'user_id': receipt.userId,
        'transaction_id': receipt.transactionId,
        'type': receipt.type,
        'currency': receipt.currency,
        'email': receipt.email,
        'date': receipt.date.toIso8601String(),
        'file_path': receipt.filePath,
      },
    );
    talker.debug('Receipt created: $receipt.receiptId');
    final jsonString = jsonEncode(receipt.toJson());
    return Response.ok(jsonString);
  } catch (e, st) {
    talker.error('Error creating receipt', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> downloadReceipt(Request request, String id) async {
  try {
    final receiptId = int.tryParse(id);

    if (receiptId == null) {
      talker.error('Invalid receipt ID');
      return Response.badRequest(body: 'Invalid receipt ID');
    }

    final result = await connection.execute(
      'SELECT file_path FROM "Receipt" WHERE receipt_id = @id',
      parameters: {'receipt_id': receiptId},
    );

    if (result.isEmpty) {
      return Response.notFound('Receipt not found');
    }

    final filePath = result.first.toColumnMap()['file_path'] as String;
    final file = File(filePath);

    if (!await file.exists()) {
      return Response.notFound('File not found');
    }

    final bytes = await file.readAsBytes();

    return Response.ok(
      bytes,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/pdf',
        'content-disposition': 'attachment; filename=receipt_$id.pdf',
      },
    );
  } catch (e, st) {
    talker.error('Error downloading receipt', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}
