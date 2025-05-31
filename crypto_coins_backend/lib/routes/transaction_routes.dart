import 'dart:convert';

import 'package:crypto_coins_backend/config/env.dart';
import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/transaction.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

Future<Response> createTransaction(Request request) async {
  try {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.forbidden('Missing or invalid Authorization header');
    }

    final token = authHeader.substring(7);
    final jwt = JWT.verify(token, SecretKey(env['SECRET_KEY']!));

    final userIdFromToken = jwt.payload['user_id'];

    final payload = await request.readAsString();
    final Map<String, dynamic> transactionMap = jsonDecode(payload);
    final transaction = Transaction.fromJson(transactionMap);

    if (transaction.userId != userIdFromToken) {
      return Response.forbidden('User ID mismatch');
    }

    final balanceResult = await connection.execute(
      Sql.named('SELECT balance FROM "User" WHERE user_id = @user_id'),
      parameters: {'user_id': transaction.userId},
    );

    if (balanceResult.isEmpty) {
      return Response.notFound('User not found');
    }

    final rawBalance = balanceResult.first.toColumnMap()['balance'];
    final curBalance = parseToDouble(rawBalance);
    final totalPrice =
        transaction.amount.toDouble() * transaction.rate.toDouble();

    if (transaction.type == 'buy' && curBalance < totalPrice) {
      return Response.badRequest(body: 'Insufficient balance');
    }

    final updatedBalance =
        transaction.type == 'buy'
            ? curBalance - totalPrice
            : curBalance + totalPrice;
    await connection.execute(
      Sql.named(
        'UPDATE "User" SET balance = @balance WHERE user_id = @user_id',
      ),
      parameters: {'balance': updatedBalance, 'user_id': transaction.userId},
    );

    final query = Sql.named(
      'INSERT INTO "Transaction"(user_id, crypto_name, currency, amount, type, total_price, rate, date)'
      'VALUES(@user_id, @crypto_name, @currency, @amount, @type, @total_price, @rate, @date) '
      'RETURNING transaction_id',
    );

    final result = await connection.execute(
      query,
      parameters: {
        'user_id': transaction.userId,
        'crypto_name': transaction.cryptoName,
        'currency': transaction.currency,
        'amount': transaction.amount,
        'type': transaction.type,
        'total_price': transaction.totalPrice,
        'rate': transaction.rate,
        'date': transaction.date.toIso8601String(),
      },
    );

    final transactionId = result.first.toColumnMap()['transaction_id'] as int?;
    if (transactionId == null) {
      talker.error('❌ transaction_id is null');
      return Response.internalServerError(body: 'c is null');
    }

    talker.debug('Transaction created: User ID - ${transaction.userId}');
    final jsonString = jsonEncode({
      ...transaction.toJson(),
      'receipt_id': transactionId,
    });
    return Response.ok(jsonString);
  } catch (e, st) {
    talker.error('Error creating transaction', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> loadTransaction(Request request, String id) async {
  try {
    final userId = int.tryParse(id);

    if (userId == null) {
      talker.warning('user_id not provided');
      return Response.badRequest(body: 'Missing user_id');
    }

    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.forbidden('Missing or invalid Authorization header');
    }

    final token = authHeader.substring(7);
    final jwt = JWT.verify(token, SecretKey(env['SECRET_KEY']!));
    final userIdFromToken = jwt.payload['user_id'];

    if (userId != userIdFromToken) {
      return Response.forbidden('User ID mismatch');
    }

    final result = await connection.execute(
      Sql.named('SELECT * FROM "Transaction" WHERE user_id = @user_id'),
      parameters: {'user_id': userId},
    );

    if (result.isEmpty) {
      talker.warning('Transactions not found');
      return Response.ok(jsonEncode([]));
    }

    final transactions =
        result.map((row) => Transaction.fromJson(row.toColumnMap())).toList();

    talker.debug('✅ Loaded ${transactions.length} transactions');
    return Response.ok(jsonEncode(transactions));
  } catch (e, st) {
    talker.error('Loading transactions error', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}
