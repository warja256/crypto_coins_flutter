import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_event.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = GetIt.I<Talker>();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      final loggedIn = await AuthService.isLoggedIn();
      if (loggedIn) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      try {
        final success = await AuthService.login(event.email, event.password);
        if (success) {
          emit(AuthAuthenticated());
        } else {
          emit(AuthError(exception: Exception('Invalid credentials')));
        }

        talker.debug('Succesful login');
      } catch (e) {
        emit(AuthError(exception: e));
      }
    });

    on<RegisterRequested>(
      (event, emit) async {
        try {
          final success =
              await AuthService.register(event.email, event.password);
          if (success) {
            emit(AuthAuthenticated());
          } else {
            emit(AuthError(exception: Exception('Invalid credentials')));
          }
          talker.debug('Succesful registeration');
        } catch (e) {
          emit(AuthError(exception: e));
        }
      },
    );

    on<LogOutRequested>(
      (event, emit) async {
        try {
          await AuthService.logOut();
          emit(AuthUnauthenticated());
        } catch (e) {
          emit(AuthError(exception: e));
        }
      },
    );

    add(AuthCheckRequested());
  }
}
