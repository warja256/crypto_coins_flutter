// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_event.dart';
import 'package:crypto_coins_flutter/features/auth/bloc/auth_state.dart';
import 'package:crypto_coins_flutter/features/auth/widgets/elevated_button.dart';
import 'package:crypto_coins_flutter/features/auth/widgets/text_field.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();

  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  final confirmPasswordFieldKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
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
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 148,
                          ),
                          Row(
                            children: [
                              Text(
                                'Sign Up',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 46,
                          ),
                          Text(
                            'Email',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextFieldWidget(
                            fieldKey: emailFieldKey,
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            isSuffixIcon: false,
                            focusNode: emailFocusNode,
                            nextFocusNode: passwordFocusNode,
                            validator: (String? value) {
                              if (value == null) {
                                return 'Email is required';
                              }
                              final isValid =
                                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(value);
                              if (!isValid) {
                                return 'Invalid email';
                              }

                              return null;
                            },
                            autoValidate: _autoValidate,
                            onFieldSubmitted: () {
                              final valid =
                                  emailFieldKey.currentState?.validate() ??
                                      false;
                              if (valid) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              }
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Password',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextFieldWidget(
                            fieldKey: passwordFieldKey,
                            controller: passwordController,
                            textInputType: TextInputType.visiblePassword,
                            isSuffixIcon: true,
                            focusNode: passwordFocusNode,
                            nextFocusNode: confirmPasswordFocusNode,
                            validator: (String? value) {
                              if (value == null) {
                                return 'Password is required';
                              }
                              final password = passwordController.text;
                              if (!(password.length >= 8 &&
                                  password.contains(RegExp(r'[A-Z]')) &&
                                  password.contains(RegExp(r'[0-9]')) &&
                                  password.contains(RegExp(r'[!@#\$&*~]')))) {
                                return 'Password must be at least 8 characters and include an uppercase letter, number, and symbol.';
                              }
                              return null;
                            },
                            autoValidate: _autoValidate,
                            onFieldSubmitted: () {
                              final valid =
                                  passwordFieldKey.currentState?.validate() ??
                                      false;
                              if (valid) {
                                FocusScope.of(context)
                                    .requestFocus(confirmPasswordFocusNode);
                              }
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Confirm password',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextFieldWidget(
                            fieldKey: confirmPasswordFieldKey,
                            controller: confirmPasswordController,
                            textInputType: TextInputType.visiblePassword,
                            isSuffixIcon: true,
                            focusNode: confirmPasswordFocusNode,
                            validator: (String? value) {
                              if (value == null) {
                                return 'Confirm your password';
                              }
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                return 'Wrong password';
                              }
                              return null;
                            },
                            autoValidate: _autoValidate,
                            onFieldSubmitted: () {
                              final valid = confirmPasswordFieldKey.currentState
                                      ?.validate() ??
                                  false;
                              if (valid) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.router.replace(LogInRoute());
                      },
                      child: Text.rich(
                        TextSpan(
                            text: 'Already have an account?',
                            style: Theme.of(context).textTheme.titleSmall,
                            children: [
                              TextSpan(
                                text: ' Log in',
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
                      text: 'Sign Up',
                      onPressed: () {
                        setState(() {
                          _autoValidate = true;
                        });

                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(RegisterRequested(
                                email: emailController.text,
                                password: passwordController.text,
                              ));
                          GetIt.I<Talker>()
                              .debug('Форма валидна, можно отправлять данные');
                        } else {
                          GetIt.I<Talker>()
                              .warning('Форма не прошла валидацию');
                        }
                      }),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
