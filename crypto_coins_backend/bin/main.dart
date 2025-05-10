import 'package:crypto_coins_backend/db/db.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  await connectToDataBase();
  try {
    final result = await connection.execute('SELECT NOW()');
    talker.debug('🕒 Current time from DB: ${result.first[0]}');
  } catch (e) {
    talker.error('❌ Query failed: $e');
  }
}
