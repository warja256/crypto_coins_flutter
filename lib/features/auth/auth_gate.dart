import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_state.dart';
import 'package:crypto_coins_flutter/features/auth/log_in/view/log_in_screen.dart';
import 'package:crypto_coins_flutter/features/home/home_page.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          // Показываем дочерние маршруты, начиная с /home
          return AutoRouter();
        } else if (state is AuthInitial || state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Тоже возвращаем AutoRouter, так как логин — это вложенный маршрут
          return const LogInScreen();
        }
      },
    );
  }
}
