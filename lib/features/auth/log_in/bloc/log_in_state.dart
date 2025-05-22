import 'package:crypto_coins_flutter/repositories/user/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class LogInState extends Equatable {
  const LogInState();

  @override
  List<Object?> get props => [];
}

class LogInInitial extends LogInState {}

class LogInLoading extends LogInState {}

class LogInSuccess extends LogInState {
  final User user;

  LogInSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class LogInFailure extends LogInState {
  final Object exception;
  const LogInFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
