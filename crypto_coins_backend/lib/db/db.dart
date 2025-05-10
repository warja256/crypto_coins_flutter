import 'package:postgres/postgres.dart';
import 'package:talker/talker.dart';

late Connection connection;

Future<void> connectToDataBase() async {
  final talker = Talker();

  try {
    connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'cryptocoins',
        username: 'varvarakusaeva',
        password: 'Privet2024',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
    talker.debug('✅ Connected to PostgreSQL');
  } catch (e, st) {
    talker.error('❌ Failed to connect to PostgreSQL', e, st);
  }
}
