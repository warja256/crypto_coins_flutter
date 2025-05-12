import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/routes/auth_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:talker/talker.dart';

void main() async {
  final talker = Talker();
  GetIt.I.registerSingleton<Talker>(talker);

  await connectToDataBase();

  final router = Router();

  router.post('/api/register', registerUser);
  router.post('/api/auth', authUser);

  router.get('/api/hello', (Request request) {
    return Response.ok('Hello, Varvara! Your API is working 🎉');
  });

  final handler = const Pipeline()
      .addMiddleware(
        logRequests(
          logger: (msg, isError) {
            isError ? talker.error(msg) : talker.info(msg);
          },
        ),
      )
      .addHandler(router);

  final server = await shelf_io.serve(handler, 'localhost', 3000);
  talker.debug(
    'Server is running http://${server.address.host}:${server.port}',
  );
}
