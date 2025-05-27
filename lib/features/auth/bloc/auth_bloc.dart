import 'package:crypto_coins_flutter/core/api_Client.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_event.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      try {
        emit(AuthLoading());
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
          emit(AuthLoading());
          final success =
              await AuthService.register(event.email, event.password);
          emit(AuthAuthenticated());
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
  }
}
