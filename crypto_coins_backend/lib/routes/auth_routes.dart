import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import '../config/env.dart';

Future<Response> registerUser(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> userMap = jsonDecode(payload);
    final user = User.fromJson(userMap);
    final emailCheck = await connection.execute(
      Sql.named('SELECT * from "User" WHERE email = @email'),
      parameters: {'email': user.email},
    );
    if (emailCheck.isNotEmpty) {
      talker.warning('Email is already in our system');
      return Response(409, body: 'Email is already in use');
    }

    final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());

    final result = await connection.execute(
      Sql.named(
        'INSERT INTO "User"(email, password) VALUES(@email, @hashedPassword) RETURNING user_id',
      ),
      parameters: {'email': user.email, 'hashedPassword': hashedPassword},
    );

    final userId = result.first[0];

    final jwt = JWT({'user_id': userId, 'email': user.email});
    final secretKey = env['SECRET_KEY'];
    final token = jwt.sign(SecretKey(secretKey!));

    talker.debug('✅ User registered: ${user.email} (ID: $userId)');

    final responseUser = {
      'message': "User registered successfully",
      'token': token,
    };

    talker.debug('✅ User registered: $user.email');
    return Response.ok(jsonEncode(responseUser));
  } catch (e, st) {
    talker.error('❌ Registration error', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> authUser(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> userMap = jsonDecode(payload);
    final user = User.fromJson(userMap);

    final result = await connection.execute(
      Sql.named('SELECT password FROM "User" WHERE email = @email'),
      parameters: {'email': user.email},
    );

    if (result.isEmpty) {
      talker.error('❌ User not found');
      return Response.forbidden('Invalid credentials');
    }

    final storedHashedPassword = result.first[0];

    if (storedHashedPassword is String) {
      if (BCrypt.checkpw(user.password, storedHashedPassword)) {
        final userIdResult = await connection.execute(
          Sql.named('SELECT user_id FROM "User" WHERE email = @email'),
          parameters: {'email': user.email},
        );
        final userId = userIdResult.first[0];
        final jwt = JWT({'user_id': userId, 'email': user.email});
        final token = jwt.sign(SecretKey(env['SECRET_KEY']!));

        talker.debug('✅ User logged in successfully: ${user.email}');

        return Response.ok(
          jsonEncode({'message': 'Authentication successful', 'token': token}),
        );
      } else {
        talker.error('❌ Invalid credentials');
        return Response.forbidden('Invalid credentials');
      }
    } else {
      talker.error('❌ Stored password is not a valid string');
      return Response.internalServerError(
        body: 'Internal error: Invalid password format',
      );
    }
  } catch (e, st) {
    talker.error('❌ Authentication error', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> getProfile(Request request) async {
  try {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.forbidden('Missing or invalid Authorization header');
    }

    final token = authHeader.substring(7);
    final jwt = JWT.verify(token, SecretKey(env['SECRET_KEY']!));
    print('Authorization header: ${request.headers['Authorization']}');

    final userId = jwt.payload['user_id'];

    final result = await connection.execute(
      Sql.named('SELECT * FROM "User" WHERE user_id = @user_id'),

      parameters: {'user_id': userId},
    );

    if (result.isEmpty) {
      return Response.forbidden('User not found');
    }

    final user = User.fromJson(result.first.toColumnMap());
    talker.debug('Verified token in getProfile: payload ${jwt.payload}');
    return Response.ok(
      jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, st) {
    talker.error('Failed to verify token in getProfile: $e\n$st');
    return Response.forbidden('Invalid token');
  }
}
