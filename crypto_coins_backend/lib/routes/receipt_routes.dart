import 'dart:convert';
import 'dart:io';
import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/receipt.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

Future<Response> createReceipt(Request request) async {
  try {
    final payload = await request.readAsString();
    talker.info('createReceipt called with payload: $payload');

    final Map<String, dynamic> receiptMap = jsonDecode(payload);
    final receipt = Receipt.fromJson(receiptMap);

    final result = await connection.execute(
      Sql.named(
        'INSERT INTO "Receipt"(transaction_id, user_id, type, currency, email, date, file_path) '
        'VALUES(@transaction_id, @user_id, @type, @currency, @email, @date, @file_path) '
        'RETURNING receipt_id',
      ),
      parameters: {
        'user_id': receipt.userId,
        'transaction_id': receipt.transactionId,
        'type': receipt.type,
        'currency': receipt.currency,
        'email': receipt.email,
        'date': receipt.date.toIso8601String(),
        'file_path': receipt.filePath,
      },
    );
    talker.debug(
      'Insert result: $result, rows affected: ${result.affectedRows}',
    );

    final receiptId = result.isNotEmpty ? result.first[0] as int? : null;
    if (receiptId == null) {
      talker.error('❌ receipt_id is null after database insert');
      return Response.internalServerError(body: 'receipt_id is null');
    }
    talker.debug(
      'Receipt created: User ID - ${receipt.userId}, receiptId: $receiptId',
    );
    final jsonString = jsonEncode({
      ...receipt.toJson(),
      'receipt_id': receiptId,
    });
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
      Sql.named('SELECT * FROM "Receipt" WHERE receipt_id = @receipt_id'),
      parameters: {'receipt_id': receiptId},
    );

    if (result.isEmpty) {
      return Response.notFound('Receipt not found');
    }

    final receiptMap = result.first.toColumnMap();
    final receipt = Receipt.fromJson(receiptMap);
    if (receipt.receiptId == null) {
      talker.error('❌ Receipt ID is null after fromJson');
      return Response.internalServerError(body: 'Receipt ID is null');
    }

    final filePath = 'receipts/receipt_$id.pdf';
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Receipt #$id'),
              pw.Text('Receipt ID: ${receipt.receiptId}'),
              pw.Text('User ID: ${receipt.userId}'),
              pw.Text('Transaction ID: ${receipt.transactionId}'),
              pw.Text('Type: ${receipt.type}'),
              pw.Text('Currency: ${receipt.currency}'),
              pw.Text('Email: ${receipt.email}'),
              pw.Text('Date: ${receipt.date.toLocal()}'),
              pw.Text('File Path: ${receipt.filePath}'),
            ],
          );
        },
      ),
    );

    final dir = Directory('receipts');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    final bytes = await file.readAsBytes();
    if (!await file.exists()) {
      return Response.notFound('File not found');
    }
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
