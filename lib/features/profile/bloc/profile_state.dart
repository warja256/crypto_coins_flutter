// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:crypto_coins_flutter/repositories/models/transaction.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class TransationsLoading extends ProfileState {}

class TransationsLoaded extends ProfileState {
  final List<Transaction> transactionList;
  TransationsLoaded({
    required this.transactionList,
  });

  @override
  List<Object?> get props => [transactionList];
}

class TransationsLoadingFailure extends ProfileState {
  final Object exception;
  TransationsLoadingFailure({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}
