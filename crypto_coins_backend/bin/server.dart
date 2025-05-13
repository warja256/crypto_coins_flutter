import 'package:crypto_coins_backend/db/db.dart';
import 'package:crypto_coins_backend/middleware/auth_middleware.dart';
import 'package:crypto_coins_backend/routes/auth_routes.dart';
import 'package:crypto_coins_backend/routes/receipt_routes.dart';
import 'package:crypto_coins_backend/routes/transaction_routes.dart';
import 'package:crypto_coins_backend/routes/user_routes.dart';
import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:talker/talker.dart';

void main() async {
  DotEnv().load();
  final talker = Talker();
  GetIt.I.registerSingleton<Talker>(talker);

  await connectToDataBase();

  final router = Router();

  router.post('/api/register', registerUser);
  router.post('/api/auth', authUser);

  router.all('/api/user/*', checkAuth());
  router.all('/api/transaction/*', checkAuth());
  router.all('/api/receipt/*', checkAuth());

  router.post('/api/receipt/create', createReceipt);
  router.get('/api/receipt/<id>', downloadReceipt);

  router.post('/api/transaction/create', createTransaction);
  router.get('/api/transaction/<id>', loadTransaction);

  router.get('/api/user/<id>', getUserData);
  router.post('/api/user/fav/add', addToFav);
  router.delete('/api/user/fav/remove', removeFromFav);
  router.get('/api/user/fav/<id>', loadFavorites);

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
