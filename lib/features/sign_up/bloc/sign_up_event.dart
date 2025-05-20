// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:crypto_coins_flutter/repositories/user/models/user.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpStarted extends SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final User user;
  final Completer<void>? completer;

  SignUpSubmitted({
    required this.user,
    this.completer,
  });

  @override
  List<Object?> get props => [user];
}

class SignUpValidationFailed extends SignUpEvent {
  final Map<String, String> errors;

  SignUpValidationFailed({required this.errors});

  @override
  List<Object?> get props => [errors];
}
