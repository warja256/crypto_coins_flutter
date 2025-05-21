// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypto_coins_flutter/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:crypto_coins_flutter/features/sign_up/bloc/sign_up_state.dart';

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
                    TextFieldedWidget(
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      isSuffixIcon: false,
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Password',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextFieldedWidget(
                      controller: passwordController,
                      textInputType: TextInputType.visiblePassword,
                      isSuffixIcon: true,
                      focusNode: passwordFocusNode,
                      nextFocusNode: confirmPasswordFocusNode,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Confirm password',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextFieldedWidget(
                      controller: confirmPasswordController,
                      textInputType: TextInputType.visiblePassword,
                      isSuffixIcon: true,
                      focusNode: confirmPasswordFocusNode,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                onPressed: () {},
                child: Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFF6262D9),
                            Color(0xFF9D62D9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Container(
                    height: 54,
                    alignment: Alignment.center,
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
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

class TextFieldedWidget extends StatefulWidget {
  const TextFieldedWidget({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.isSuffixIcon,
    required this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isSuffixIcon;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;

  @override
  void dispose() {
    focusNode.dispose();
  }

  State<TextFieldedWidget> createState() => _TextFieldedWidgetState();
}

class _TextFieldedWidgetState extends State<TextFieldedWidget> {
  bool isPasswordvisible = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextFormField(
        focusNode: widget.focusNode,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Color(0xFFE4E4F0)),
        cursorHeight: 15,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        textInputAction: TextInputAction.done,
        autofocus: true,
        cursorColor: Color(0xFFE4E4F0),
        obscureText: isPasswordvisible,
        onFieldSubmitted: (_) {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          fillColor: Color(0xFF4C4C65),
          filled: true,
          suffixIcon: widget.isSuffixIcon
              ? IconButton(
                  onPressed: () =>
                      setState(() => isPasswordvisible = !isPasswordvisible),
                  icon: isPasswordvisible
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility))
              : Container(
                  width: 0,
                ),
          suffixIconColor: Color(0xFFE4E4F0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFA7A7CC), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE4E4F0), width: 1)),
        ),
      ),
    );
  }
}
