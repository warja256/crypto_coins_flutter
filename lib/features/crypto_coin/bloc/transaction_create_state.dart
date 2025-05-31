import 'package:equatable/equatable.dart';

abstract class TransactionCreateState extends Equatable {
  const TransactionCreateState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionCreateState {}

class TransactionCreating extends TransactionCreateState {}

class TransactionCreated extends TransactionCreateState {}

class TransactionCreateError extends TransactionCreateState {
  final String exception;
  const TransactionCreateError({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}
