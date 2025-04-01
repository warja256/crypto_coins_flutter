import 'package:crypto_coins_flutter/theme/bloc/theme_event_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEventBloc, ThemeStateBloc> {
  ThemeBloc(dynamic themeMode)
      : super(ThemeStateBloc(themeMode: themeMode.dark)) {
    on<ToggleThemeEvent>((event, emit) {
      final newTheme =
          state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      emit(ThemeStateBloc(themeMode: newTheme));
    });
  }
}
