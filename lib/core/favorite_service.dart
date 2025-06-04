import 'dart:convert';

import 'package:crypto_coins_flutter/core/api_client.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:crypto_coins_flutter/repositories/models/favorite_crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<bool> addToFavCrypto(int userId, String cryptoName) async {
    try {
      final payload = {'user_id': userId, 'crypto_name': cryptoName};
      talker.debug('Adding to favorite User($userId) $cryptoName');
      final response = await ApiClient.post('/api/user/fav/add', payload);

      final rawData = response.data;
      final data = rawData is String ? jsonDecode(rawData) : rawData;
      talker.debug('Decoded response data: $data');
      if (response.statusCode == 200) {
        talker.debug('Crypto added to favorites');
        return true;
      } else {
        talker.error('Crypto not added to favorites');
        return false;
      }
    } catch (e) {
      talker.error('❌ Adding to favorite error: $e');
      return false;
    }
  }

  static Future<bool> removeFromFavCrypto(int userId, String cryptoName) async {
    try {
      final payload = {'user_id': userId, 'crypto_name': cryptoName};
      talker.debug('Removing from favorite User($userId) $cryptoName');
      final response = await ApiClient.post('/api/user/fav/remove', payload);

      final rawData = response.data;
      final data = rawData is String ? jsonDecode(rawData) : rawData;
      talker.debug('Decoded response data: $data');

      if (response.statusCode == 200) {
        talker.debug('Crypto removed from favorites');
        return true;
      } else {
        talker.error('Crypto not removed from favorites');
        return false;
      }
    } catch (e) {
      talker.error('❌ Removing from favorite error: $e');
      return false;
    }
  }

  static Future<List<FavoriteCrypto>> loadFavoritesCrypto(String id) async {
    try {
      final response = await ApiClient.get('/api/user/fav/$id');
      final rawData = response.data;
      final data = jsonDecode(rawData);

      if (data is List) {
        final favorites = data
            .map(
                (json) => FavoriteCrypto.fromJson(json as Map<String, dynamic>))
            .toList();
        return favorites;
      } else {
        talker.error('❌ Invalid data format: Expected a list');
        return [];
      }
    } catch (e) {
      talker.error('❌ Failed to get user favorites: $e');
      rethrow;
    }
  }
}
