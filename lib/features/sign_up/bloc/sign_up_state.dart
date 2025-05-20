import 'package:crypto_coins_flutter/repositories/user/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User user;

  SignUpSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignUpFailure extends SignUpState {
  final Object exception;
  const SignUpFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
