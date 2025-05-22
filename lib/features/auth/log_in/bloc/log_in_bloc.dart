import 'package:crypto_coins_flutter/features/auth/log_in/bloc/log_in_event.dart';
import 'package:crypto_coins_flutter/features/auth/log_in/bloc/log_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInInitial()) {
    on<LogInStarted>(
      (event, emit) {
        emit(LogInInitial());
        GetIt.I<Talker>().debug('Авторизация началась');
      },
    );

    on<LogInSubmitted>(
      (event, emit) async {
        emit(LogInLoading());
        try {
          //TODO добавить вызов репозитория
          await Future.delayed(const Duration(seconds: 2));
          emit(LogInSuccess(user: event.user));
          GetIt.I<Talker>().debug('Авторизация прошла успешно');
        } catch (e) {
          GetIt.I<Talker>().error('Ошибка при авторизации');
          emit(LogInFailure(exception: e));
        } finally {
          event.completer?.complete();
        }
      },
    );

    on<LogOutRequested>(
      (event, emit) {
        try {
          emit(LogInInitial());
          GetIt.I<Talker>().debug('Пользователь вышел из системы');
        } catch (e) {
          emit(LogInFailure(exception: e));
          GetIt.I<Talker>().error('Ошибка при выходе из системы');
        }
      },
    );

    on<LogInCheckStatus>(
      (event, emit) {
        //TODO реализация с репозиторием
      },
    );
  }
}
