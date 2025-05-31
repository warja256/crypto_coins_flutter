// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class TransactionListEvent extends Equatable {
  const TransactionListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionList extends TransactionListEvent {
  final int userId;
  final Completer? completer;
  const LoadTransactionList({
    required this.userId,
    this.completer,
  });
}
