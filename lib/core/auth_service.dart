import 'dart:convert';

import 'package:crypto_coins_flutter/core/api_Client.dart';
import 'package:crypto_coins_flutter/repositories/user/models/user.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = GetIt.I<Talker>();

class AuthService {
  /// Сохраняем только токен
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  /// Вход
  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.post(
        '/api/auth',
        {'email': email, 'password': password},
      );
      final rawData = response.data;
      final data = jsonDecode(rawData);
      final token = data['token'];

      if (token == null) {
        talker.error('❌ Token not found in response');
        return false;
      }

      await _saveToken(token);
      talker.debug('✅ Successful login');
      return true;
    } catch (e) {
      talker.error('❌ Login error: $e');
      return false;
    }
  }

  /// Регистрация
  static Future<bool> register(String email, String password) async {
    try {
      final response = await ApiClient.post(
        '/api/register',
        {'email': email, 'password': password},
      );
      final rawData = response.data;
      final data = jsonDecode(rawData);

      talker.debug('Response from register: $data');

      final token = data['token'];

      if (token == null) {
        talker.error('❌ Token not found in response');
        return false;
      }

      await _saveToken(token);
      talker.debug('✅ Successful registration');
      return true;
    } catch (e) {
      talker.error('❌ Registration error: $e');
      return false;
    }
  }

  /// Выход
  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  /// Проверка авторизации
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null && token.isNotEmpty;
  }

  static Future<User> getProfile() async {
    try {
      final token = await _getToken();
      final response = await ApiClient.get(
        '/api/profile',
      );
      final data = response.data;

      if (token == null) {
        talker.error('❌ Token not found in response');
      }

      final user = User.fromJson(data);

      talker.debug('User data is found: User ID ${user.userId}');
      return user;
    } catch (e) {
      talker.error('❌ Failed to get user profile: $e');
      rethrow;
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}
