import 'dart:convert';

import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/models/favorite_crypto.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

Future<Response> addToFav(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> requestData = jsonDecode(payload);
    final userId = int.tryParse(requestData['user_id'].toString());
    final cryptoName = requestData['crypto_name'];

    if (userId == null || cryptoName == null) {
      return Response.badRequest(body: 'Missing user_id or crypto_name');
    }

    final existingFavorite = await connection.execute(
      Sql.named(
        'SELECT * FROM "favoritecrypto" WHERE user_id = @user_id and crypto_name = @crypto_name',
      ),
      parameters: {'user_id': userId, 'crypto_name': cryptoName},
    );

    if (existingFavorite.isNotEmpty) {
      return Response.ok('Crypto is already in your favorites');
    }

    await connection.execute(
      Sql.named(
        'INSERT INTO "favoritecrypto"(user_id, crypto_name) VALUES(@user_id, @crypto_name)',
      ),
      parameters: {'user_id': userId, 'crypto_name': cryptoName},
    );
    talker.debug('✅ Crypto added to favorites: $cryptoName');
    return Response.ok(
      jsonEncode({'message': 'Crypto was added to favorites'}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, st) {
    talker.error('Error adding crypto to favorites', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> removeFromFav(Request request) async {
  try {
    final payload = await request.readAsString();
    final Map<String, dynamic> requestData = jsonDecode(payload);
    final userId = int.tryParse(requestData['user_id'].toString());
    final cryptoName = requestData['crypto_name'];

    if (userId == null || cryptoName == null) {
      return Response.badRequest(body: 'Missing user_id or crypto_name');
    }

    final existingFavorite = await connection.execute(
      Sql.named(
        'SELECT * FROM "favoritecrypto" WHERE user_id = @user_id and crypto_name = @crypto_name',
      ),
      parameters: {'user_id': userId, 'crypto_name': cryptoName},
    );

    if (existingFavorite.isEmpty) {
      return Response.ok('Crypto is already deleted from favorites');
    }

    await connection.execute(
      Sql.named(
        'DELETE FROM "favoritecrypto" WHERE user_id = @user_id and crypto_name = @crypto_name',
      ),
      parameters: {'user_id': userId, 'crypto_name': cryptoName},
    );
    talker.debug('✅ Crypto deleted from favorites: $cryptoName');
    return Response.ok(
      jsonEncode({'message': 'Crypto deleted from favorites'}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, st) {
    talker.error('Error deleting crypto from favorites', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> loadFavorites(Request request, String id) async {
  try {
    final userId = int.tryParse(id);

    if (userId == null) {
      talker.error('User not found');
      return Response.notFound('User not found');
    }

    final result = await connection.execute(
      Sql.named('SELECT * FROM "favoritecrypto" WHERE user_id = @user_id'),
      parameters: {'user_id': userId},
    );

    if (result.isEmpty) {
      talker.warning('Favorites are empty');
      return Response.ok(jsonEncode([]));
    }

    final favorites =
        result
            .map((row) => FavoriteCrypto.fromJson(row.toColumnMap()))
            .toList();
    talker.debug('Loaded ${favorites.length} favorite cryptos');
    return Response.ok(jsonEncode(favorites));
  } catch (e, st) {
    talker.error('Loading favorites error', e, st);
    return Response.internalServerError(body: 'Error: $e');
  }
}
