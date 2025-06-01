import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = GetIt.I<Talker>();

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<Options> getOptions() async {
    final token = await _getToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<Response> post(String path, Map<String, dynamic> data) async {
    final options = await getOptions();
    return _dio.post(path, data: data, options: options);
  }

  static Future<Response> get(String path, {Options? options}) async {
    options ??= await getOptions();
    print('Request headers: ${options.headers}');
    return _dio.get(path, options: options);
  }

  static Future<Response> delete(
      String path, Map<String, dynamic>? data) async {
    final options = await getOptions();
    return _dio.delete(path, data: data, options: options);
  }
}
