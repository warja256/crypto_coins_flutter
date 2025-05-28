import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData(
  splashColor: Colors.black54,
  focusColor: Colors.white,
  hintColor: Colors.black54,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF16171A),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    scrolledUnderElevation: 0.0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  scaffoldBackgroundColor: Color(0xFF16171A),
  useMaterial3: true,
  dividerColor: Colors.white10,
  textTheme: TextTheme(
    headlineSmall: GoogleFonts.nunitoSans(
        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
    titleSmall: GoogleFonts.nunitoSans(
        color: Color(0xFFE4E4F0), fontSize: 12, fontWeight: FontWeight.w400),
    labelMedium: GoogleFonts.nunitoSans(
        color: Color(0xFFD5D5E0), fontSize: 22, fontWeight: FontWeight.w600),
    displaySmall: GoogleFonts.nunitoSans(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
    labelLarge: GoogleFonts.nunitoSans(
        color: Color(0xFFA7A7CC), fontSize: 40, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.nunitoSans(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.nunitoSans(
        color: Color(0xFFE4E4F0), fontSize: 34, fontWeight: FontWeight.w600),
    bodyMedium: GoogleFonts.nunitoSans(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    bodySmall: GoogleFonts.nunitoSans(
        color: Color(0xFFA7A7CC), fontSize: 15, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.nunitoSans(
        color: Color(0xFFE4E4F0), fontSize: 17, fontWeight: FontWeight.bold),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF16171A),
    elevation: 4,
    selectedIconTheme: IconThemeData(color: Color(0xFF7878FA)),
    unselectedIconTheme: IconThemeData(color: Color(0xFFA7A7CC)),
  ),
  shadowColor: const Color.fromARGB(255, 23, 21, 21),
  indicatorColor: Color(0xFFA7A7CC),
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
    bodyLarge: TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
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
