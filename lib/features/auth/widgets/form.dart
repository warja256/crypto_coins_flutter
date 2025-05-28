import 'package:crypto_coins_flutter/features/auth/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailFieldKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required bool autoValidate,
    required this.passwordFieldKey,
    required this.passwordController,
  })  : _formKey = formKey,
        _autoValidate = autoValidate;

  final GlobalKey<FormState> _formKey;
  final GlobalKey<FormFieldState> emailFieldKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool _autoValidate;
  final GlobalKey<FormFieldState> passwordFieldKey;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
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
                'Log In',
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
              final isValid =
                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
              if (!isValid) {
                return 'Invalid email';
              }

              return null;
            },
            autoValidate: _autoValidate,
            onFieldSubmitted: () {
              final valid = emailFieldKey.currentState?.validate() ?? false;
              if (valid) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
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
              return null;
            },
            autoValidate: _autoValidate,
            onFieldSubmitted: () {
              final valid = passwordFieldKey.currentState?.validate() ?? false;
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
    );
  }
}
