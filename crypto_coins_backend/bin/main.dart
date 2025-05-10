import 'package:crypto_coins_backend/db/db.dart';
import 'package:talker/talker.dart';

final talker = Talker();

Future<void> insertUser() async {
  try {
    final query = '''
      INSERT INTO "User"(email, password)
      VALUES ('varya1', 'password1')
    ''';
    final result = await connection.execute(query);
    talker.debug('✅ User inserted: $result');
  } catch (e) {
    talker.error('❌ Error inserting user: $e');
  }
}

void main() async {
  await connectToDataBase();
  try {
    final result = await connection.execute('SELECT NOW()');
    print('🕒 Current time from DB: ${result.first[0]}');

    insertUser();
  } catch (e) {
    print('❌ Query failed: $e');
  }
}
