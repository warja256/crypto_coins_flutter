import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  splashColor: Colors.black54,
  focusColor: Colors.white,
  hintColor: Colors.black54,
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
    headlineLarge: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
    bodySmall: TextStyle(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.4),
        fontSize: 14,
        fontWeight: FontWeight.w700),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 49, 45, 45),
    elevation: 4,
    selectedIconTheme: IconThemeData(color: Colors.white),
    unselectedIconTheme: IconThemeData(color: Colors.grey),
  ),
  shadowColor: const Color.fromARGB(255, 23, 21, 21),
  indicatorColor: Colors.white,
);

final lightTheme = ThemeData(
  splashColor: const Color.fromARGB(255, 224, 220, 220),
  focusColor: const Color.fromARGB(255, 197, 197, 197),
  hintColor: const Color.fromARGB(255, 141, 161, 172),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFEEEEEE),
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
    scrolledUnderElevation: 0.0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),
  useMaterial3: true,
  dividerColor: Color(0xFFDDDDDD),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
    bodyMedium: const TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
    bodySmall: TextStyle(
        color: Colors.black.withOpacity(0.6),
        fontSize: 14,
        fontWeight: FontWeight.w700),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 4,
    selectedIconTheme: IconThemeData(color: Colors.blue),
    unselectedIconTheme: IconThemeData(color: Colors.grey),
  ),
  shadowColor: Color(0x26000000),
  indicatorColor: Colors.grey,
);
