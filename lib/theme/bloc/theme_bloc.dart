import 'package:crypto_coins_flutter/theme/bloc/theme_event_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEventBloc, ThemeStateBloc> {
  ThemeBloc()
      : super(ThemeStateBloc(themeMode: ThemeMode.dark, isDarkTheme: true)) {
    on<ToggleThemeEvent>((event, emit) {
      final newThemeMode =
          state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      emit(ThemeStateBloc(
        themeMode: newThemeMode,
        isDarkTheme: newThemeMode == ThemeMode.dark,
      ));
    });
  }
}
