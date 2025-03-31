import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/favourite_screen.dart';
import 'package:crypto_coins_flutter/features/home/home_page.dart';
import 'package:flutter/material.dart';
import '../features/crypto_coin/view/crypto_coin_screen.dart';
import '../features/crypto_list/view/crypto_list_screen.dart';
import '../repositories/crypto_coins/models/crypto_coin.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/', children: [
          AutoRoute(page: CryptoListRoute.page, path: 'list', children: [
            AutoRoute(page: CryptoCoinRoute.page, path: 'coin'),
          ]),
          AutoRoute(
            page: FavouriteRoute.page,
            path: 'fav',
          ),
        ]),
      ];
}
