import 'package:auto_route/auto_route.dart';

import '../features/crypto_coin/view/view.dart';
import '../features/crypto_list/view/view.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: CryptoListRoute.page, path: '/'),
        AutoRoute(page: CryptoCoinRoute.page),
      ];
}
