import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 23, 21, 21),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    scrolledUnderElevation: 0.0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.yellow,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 35, 31, 31),
  useMaterial3: true,
  dividerColor: Colors.white10,
  textTheme: TextTheme(
    bodyMedium: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
    bodySmall: TextStyle(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.4),
        fontSize: 14,
        fontWeight: FontWeight.w700),
  ),
);
