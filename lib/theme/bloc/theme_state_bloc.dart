// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeStateBloc extends Equatable {
  final ThemeMode themeMode;
  final bool isDarkTheme;

  ThemeStateBloc({
    required this.themeMode,
    required this.isDarkTheme,
  });

  @override
  List<Object> get props => [themeMode, isDarkTheme];
}
