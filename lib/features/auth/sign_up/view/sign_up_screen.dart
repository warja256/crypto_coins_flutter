// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/auth/widgets/elevated_button.dart';
import 'package:crypto_coins_flutter/features/auth/widgets/text_field.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignUpScreenView();
  }
}

class _SignUpScreenView extends StatefulWidget {
  const _SignUpScreenView({super.key});

  @override
  State<_SignUpScreenView> createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<_SignUpScreenView> {
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
  Widget build(BuildContext context) {
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
                            style: Theme.of(context).textTheme.headlineLarge,
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
                          final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(value);
                          if (!isValid) {
                            return 'Invalid email';
                          }

                          return null;
                        },
                        autoValidate: _autoValidate,
                        onFieldSubmitted: () {
                          final valid =
                              emailFieldKey.currentState?.validate() ?? false;
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
                            return 'Strong password required';
                          }
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
              ElevatedButtonWidget(
                text: 'Sign Up',
                onPressed: () {
                  context.router.replace(HomeRoute());
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
    ));
  }
}
