import 'package:crypto_coins_backend/config/env.dart';
import 'package:crypto_coins_backend/db/db.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

Middleware checkAuth() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        final authHeader = request.headers['Authorization'];
        if (authHeader == null || !authHeader.startsWith('Bearer')) {
          talker.warning('Missing or invalid token');
          return Response.forbidden('Missing or invalid token');
        }

        final token = authHeader.substring(7);

        final jwt = JWT.verify(token, SecretKey(env['SECRET_KEY']!));
        talker.debug('Token is correct: payload ${jwt.payload}');
        return await innerHandler(
          request.change(context: {'user': jwt.payload}),
        );
      } catch (e, st) {
        talker.error('Invalid token: $e\n$st');
        return Response.forbidden('Invalid token');
      }
    };
  };
}
