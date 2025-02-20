import 'package:flutter/material.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:crypto_coins_flutter/theme/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CryptoCurrenciesApp extends StatefulWidget {
  const CryptoCurrenciesApp({super.key});

  @override
  State<CryptoCurrenciesApp> createState() => _CryptoCurrenciesAppState();
}

class _CryptoCurrenciesAppState extends State<CryptoCurrenciesApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CryptoCurrencies',
      theme: darkTheme,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          TalkerRouteObserver(GetIt.I<Talker>()),
        ],
      ),
    );
  }
}
