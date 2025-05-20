import 'package:crypto_coins_flutter/features/sign_up/bloc/sign_up_event.dart';
import 'package:crypto_coins_flutter/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpStarted>(
      (event, emit) {
        emit(SignUpInitial());
        GetIt.I<Talker>().debug('Регистрация началась');
      },
    );

    on<SignUpSubmitted>(
      (event, emit) async {
        try {
          //TODO добавить вызов репозитория
          await Future.delayed(const Duration(seconds: 2));
          emit(SignUpSuccess(user: event.user));
          GetIt.I<Talker>().debug('Регистрация прошла успешно');
        } catch (e) {
          GetIt.I<Talker>().error('Ошибка при регистрации');
          emit(SignUpFailure(exception: e));
        } finally {
          event.completer?.complete();
        }
      },
    );

    on<SignUpValidationFailed>(
      (event, emit) {
        emit(SignUpFailure(exception: event.errors));
        GetIt.I<Talker>().error('Валидация данных не прошла');
      },
    );
  }
}
