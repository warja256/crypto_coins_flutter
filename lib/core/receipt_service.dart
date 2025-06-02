import 'dart:convert';
import 'dart:io';

import 'package:crypto_coins_flutter/core/api_Client.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<int?> createReceipt(
    int userId,
    int transactionId,
    String type,
    String currency,
    String email,
    DateTime date,
    String filePath,
  ) async {
    try {
      final payload = {
        'user_id': userId,
        'transaction_id': transactionId,
        'type': type,
        'currency': currency,
        'email': email,
        'date': date.toIso8601String(),
        'file_path': filePath,
      };
      talker.debug('Sending createReceipt request with payload: $payload');
      final response = await ApiClient.post('/api/receipt/create', payload);
      talker.debug(
          'createReceipt response: ${response.data}, status: ${response.statusCode}');

      final rawData = response.data;
      final data = jsonDecode(rawData);
      final receiptId = data['receipt_id'] as int?;
      if (response.statusCode == 200 && receiptId != null) {
        talker
            .debug('✅ Receipt created successfully with receiptId: $receiptId');
        return receiptId;
      } else {
        talker.warning(
            '⚠️ Receipt not created: ${data['message'] ?? 'No message'}, receiptId: $receiptId');
        return 0;
      }
    } catch (e) {
      talker.error('❌ Receipt creation error: $e');
      return 0;
    }
  }

  static Future<String> downloadReceipt(int receiptId) async {
    talker.debug('Starting downloadReceipt with receiptId: "$receiptId"');
    try {
      if (receiptId == null) {
        talker.error('Receipt ID is invalid or null');
        return 'Error: Invalid receipt ID';
      }
      final token = await _getToken();
      if (token == null) {
        talker.error('❌ Token not found in response');
      }
      final options = await ApiClient.getOptions();
      final response = await ApiClient.get(
        '/api/receipt/$receiptId',
        options: options.copyWith(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/receipt_$receiptId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.data as List<int>);
        talker.debug('File written to $filePath');

        final result = await OpenFile.open(filePath);
        if (result.type == ResultType.done) {
          talker.debug('📂 File opened successfully');
        } else {
          talker.warning('⚠️ File could not be opened: ${result.message}');
        }

        return filePath;
      } else {
        talker.error('❌ Failed to download receipt: ${response.statusCode}');
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      if (e is DioException) {
        talker.error(
            '❌ DioException caught: ${e.response?.statusCode} ${e.message}');
      } else {
        talker.error('❌ Error while downloading receipt: $e');
      }
      return 'Error: $e';
    }
  }
}
