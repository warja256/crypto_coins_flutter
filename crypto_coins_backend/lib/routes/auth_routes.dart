import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/user.dart';
import 'package:get_it/get_it.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:talker/talker.dart';

final talker = GetIt.I<Talker>();

Future<Response> registerUser(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> userMap = jsonDecode(payload);
    final user = User.fromJson(userMap);

    final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());

    final query = Sql.named(
      'INSERT INTO "User"(email, password) VALUES(@email, @hashedPassword)',
    );

    await connection.execute(
      query,
      parameters: {'email': user.email, 'hashedPassword': hashedPassword},
    );

    talker.debug('✅ User registered: $user.email');
    return Response.ok(jsonDecode(user.toJson() as String));
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
      'SELECT password FROM "User" WHERE email = @email',
      parameters: {'email': user.email},
    );

    if (result.isEmpty) {
      talker.error('❌ User not found');
      return Response.forbidden('Invalid credentials');
    }

    final storedHashedPassword = result.first[0];

    if (storedHashedPassword is String) {
      if (BCrypt.checkpw(user.password, storedHashedPassword)) {
        talker.debug('✅ User logged in successfully: ${user.email}');
        return Response.ok('Authentication successful');
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
