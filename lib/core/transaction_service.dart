import 'dart:convert';
import 'package:crypto_coins_flutter/core/api_client.dart';
import 'package:crypto_coins_flutter/repositories/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<bool> createTransaction(
      int userId,
      String cryptoName,
      String currency,
      double amount,
      String type,
      double totalPrice,
      double rate,
      DateTime date) async {
    try {
      final response = await ApiClient.post('/api/transaction/create', {
        'user_id': userId,
        'crypto_name': cryptoName,
        'currency': currency,
        'amount': amount,
        'type': type,
        'total_price': totalPrice,
        'rate': rate,
        'date': date.toIso8601String()
      });
      final rawData = response.data;
      final data = jsonDecode(rawData);

      if (response.statusCode == 200) {
        talker.debug('✅ Transaction created successfully');
        return true;
      } else {
        talker.warning('⚠️ Transaction not created: ${data['message']}');
        return false;
      }
    } catch (e) {
      talker.error('❌ Transaction error: $e');
      return false;
    }
  }

  static Future<List<Transaction>> loadTransactions(String id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        talker.error('❌ Token not found in response');
      }

      final response = await ApiClient.get('/api/transaction/$id');
      final rawData = response.data;
      final data = jsonDecode(rawData);
      talker.debug('🔍 Raw response data: $data');

      if (data is List) {
        final transactions = data
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList();
        return transactions;
      } else {
        talker.error('❌ Invalid data format: Expected a list');
        return [];
      }
    } catch (e) {
      talker.error('❌ Failed to get user transactions: $e');
      rethrow;
    }
  }
}
