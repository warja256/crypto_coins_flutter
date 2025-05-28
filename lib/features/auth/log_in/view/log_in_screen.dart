import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_event.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_state.dart';
import 'package:crypto_coins_flutter/features/auth/widgets/elevated_button.dart';
import 'package:crypto_coins_flutter/features/auth/widgets/form.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenViewState();
}

class _LogInScreenViewState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();

  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.router.replace(HomeRoute());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.exception.toString())),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FormWidget(
                        formKey: _formKey,
                        emailFieldKey: emailFieldKey,
                        emailController: emailController,
                        emailFocusNode: emailFocusNode,
                        passwordFocusNode: passwordFocusNode,
                        autoValidate: _autoValidate,
                        passwordFieldKey: passwordFieldKey,
                        passwordController: passwordController),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.router.push(SignUpRoute());
                      },
                      child: Text.rich(
                        TextSpan(
                            text: 'Don\'t have an account?',
                            style: Theme.of(context).textTheme.titleSmall,
                            children: [
                              TextSpan(
                                text: ' Sign up',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  ElevatedButtonWidget(
                    text: 'Log In',
                    onPressed: () {
                      context.read<AuthBloc>().add(LoginRequested(
                            password: passwordController.text,
                            email: emailController.text,
                          ));
                      setState(() {
                        _autoValidate = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        GetIt.I<Talker>()
                            .debug('Форма валидна, можно отправлять данные');
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
