import 'package:crypto_coins_flutter/repositories/models/transaction.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionListState extends Equatable {
  const TransactionListState();

  @override
  List<Object?> get props => [];
}

class TransactionListInitial extends TransactionListState {}

class TransactionListLoading extends TransactionListState {}

class TransactionListLoaded extends TransactionListState {
  final List<Transaction> transactionList;

  TransactionListLoaded({required this.transactionList});

  @override
  List<Object?> get props => [transactionList];
}

class TransactionListLoadingFailure extends TransactionListState {
  final Object exception;
  const TransactionListLoadingFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
