import 'package:flutter/material.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:crypto_coins_flutter/theme/theme.dart';

class CryptoCurrenciesApp extends StatelessWidget {
  const CryptoCurrenciesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoCurrencies',
      theme: darkTheme,
      routes: routes,
    );
  }
}
