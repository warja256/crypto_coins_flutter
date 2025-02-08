import 'package:flutter/material.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:crypto_coins_flutter/theme/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CryptoCurrenciesApp extends StatelessWidget {
  const CryptoCurrenciesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoCurrencies',
      theme: darkTheme,
      routes: routes,
      navigatorObservers: [TalkerRouteObserver(GetIt.I<Talker>())],
    );
  }
}
