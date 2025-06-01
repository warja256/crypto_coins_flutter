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

  static Future<bool> createReceipt(
    int userId,
    int transactionId,
    String type,
    String currency,
    String email,
    DateTime date,
    String filePath,
  ) async {
    try {
      final response = await ApiClient.post(
        '/api/receipt/create',
        {
          'user_id': userId,
          'transaction_id': transactionId,
          'type': type,
          'currency': currency,
          'email': email,
          'date': date,
          'file_path': filePath
        },
      );
      final rawData = response.data;
      final data = jsonDecode(rawData);
      if (response.statusCode == 200) {
        talker.debug('✅ Receipt created successfully');
        return true;
      } else {
        talker.warning('⚠️ Receipt not created: ${data['message']}');
        return false;
      }
    } catch (e) {
      talker.error('❌ Receipt error: $e');
      return false;
    }
  }

  static Future<String> downloadReceipt(String receiptId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        talker.error('❌ Token not found in response');
      }
      final options = await ApiClient.getOptions();
      final response = await ApiClient.get(
        '/api/receipt/download/$receiptId',
        options: options.copyWith(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/receipt_$receiptId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.data as List<int>);

        talker.debug('📄 Receipt saved at $filePath');
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
      talker.error('❌ Error while downloading receipt: $e');
      return 'Error: $e';
    }
  }
}
