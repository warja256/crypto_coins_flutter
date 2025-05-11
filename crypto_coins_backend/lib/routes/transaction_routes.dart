import 'dart:convert';

import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/transaction.dart';
import 'package:get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:talker/talker.dart';

final talker = GetIt.I<Talker>();

Future<Response> createTransaction(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> transactionMap = jsonDecode(payload);
    final transaction = Transaction.fromJson(transactionMap);

    final balanceResult = await connection.execute(
      Sql.named('SELECT balance FROM "User" WHERE user_id = @user_id'),
      parameters: {'user_id': transaction.userId},
    );

    if (balanceResult.isEmpty) {
      return Response.notFound('User not found');
    }

    final curBalance = balanceResult.first.toColumnMap()['balance'] as num;
    final totalPrice = transaction.amount * transaction.rate;

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
      'INSERT INTO "Transaction"(transaction_id, user_id, crypto_name, currency, amount, type, total_price, rate, date) VALUES(@transaction_id, @user_id, @crypto_name, @currency, @amount, @type, @total_price, @rate, @date)',
    );

    await connection.execute(
      query,
      parameters: {
        'transaction_id': transaction.transactionId,
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

    talker.debug('Transaction created: $transaction.crypto_name');
    return Response.ok(jsonDecode(transaction.toJson() as String));
  } catch (e, st) {
    talker.error('Error creating transaction', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> loadAllTransaction(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> data = jsonDecode(payload);
    final userId = int.parse(data['user_id'].toString());
    if (userId == null) {
      talker.warning('user_id not provided');
      return Response.badRequest(body: 'Missing user_id');
    }

    final result = await connection.execute(
      'SELECT * FROM "Transaction" WHERE user_id = @user_id',
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
