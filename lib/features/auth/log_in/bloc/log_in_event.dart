import 'dart:async';

import 'package:crypto_coins_flutter/repositories/user/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class LogInEvent extends Equatable {
  const LogInEvent();

  @override
  List<Object?> get props => [];
}

class LogInStarted extends LogInEvent {}

class LogInSubmitted extends LogInEvent {
  final User user;
  final Completer<void>? completer;

  LogInSubmitted({required this.user, required this.completer});

  @override
  List<Object?> get props => [user];
}

class LogOutRequested extends LogInEvent {}

class LogInCheckStatus extends LogInEvent {}
