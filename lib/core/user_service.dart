import 'dart:convert';

import 'package:crypto_coins_flutter/core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<bool> addToFav(int userId, String cryptoName) async {
    try {
      final response = await ApiClient.post('/api/user/fav/add', {
        'user_id': userId,
        'crypto_name': cryptoName,
      });

      if (response.statusCode == 200) {
        talker.debug('✅ $cryptoName added to User($userId) to favorite');
        return true;
      } else {
        talker.warning('⚠️ $cryptoName not added to User($userId) to favorite');
        return false;
      }
    } catch (e) {
      talker.error('❌ Adding to favorite error: $e');
      return false;
    }
  }
}
