import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeStateBloc extends Equatable {
  final ThemeMode themeMode;

  ThemeStateBloc({required this.themeMode});

  @override
  List<Object> get props => [];
}
