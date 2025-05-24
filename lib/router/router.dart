import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/auth/log_in/view/log_in_screen.dart';
import 'package:crypto_coins_flutter/features/favourite/view/favourite_screen.dart';
import 'package:crypto_coins_flutter/features/home/home_page.dart';
import 'package:crypto_coins_flutter/features/auth/sign_up/view/sign_up_screen.dart';
import 'package:crypto_coins_flutter/features/profile/view/profile_screen.dart';
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
          AutoRoute(page: CryptoListRoute.page, path: 'list'),
          AutoRoute(
            page: FavouriteRoute.page,
            path: 'fav',
          ),
          AutoRoute(page: ProfileRoute.page, path: 'profile'),
        ]),
        AutoRoute(page: SignUpRoute.page, path: '/signUp'),
        AutoRoute(page: LogInRoute.page, path: '/logIn'),
        AutoRoute(page: CryptoCoinRoute.page, path: '/coin'),
      ];
}
