import 'dart:convert';

import 'package:crypto_coins_flutter/core/api_Client.dart';
import 'package:crypto_coins_flutter/repositories/user/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> _saveToken(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.post(
          '/api/auth', {'email': email, 'password': password});
      final data = response.data;
      final token = data['token'];
      final user = User.fromJson(data['user']);
      if (token == null) {
        talker.error('Token not found in response');
        return false;
      }
      await _saveToken(token, user);
      talker.debug('Succesful login');
      return true;
    } catch (e) {
      talker.error('Login error: $e');
      return false;
    }
  }

  static Future<bool> register(String email, String password) async {
    try {
      final response = await ApiClient.post(
          '/api/register', {'email': email, 'password': password});
      final data = response.data;
      final token = data['token'];
      final user = User.fromJson(data['user']);
      if (token == null) {
        talker.error('Token not found in response');
        return false;
      }
      await _saveToken(token, user);
      talker.debug('Succesful registration');
      return true;
    } catch (e) {
      talker.error('Registration error: $e');
      return false;
    }
  }

  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
