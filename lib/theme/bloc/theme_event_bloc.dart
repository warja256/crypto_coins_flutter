import 'package:equatable/equatable.dart';

abstract class ThemeEventBloc extends Equatable {
  const ThemeEventBloc();

  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends ThemeEventBloc {}
