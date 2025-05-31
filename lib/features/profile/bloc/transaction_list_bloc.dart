import 'package:crypto_coins_flutter/core/transaction_service.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_event.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  TransactionListBloc() : super(TransactionListInitial()) {
    on<LoadTransactionList>((event, emit) async {
      try {
        if (state is! TransactionListLoaded) {
          emit(TransactionListLoading());
        }
        final transactionList =
            await TransactionService.loadTransactions(event.userId as String);
        emit(TransactionListLoaded(transactionList: transactionList));
      } catch (e) {
        emit(TransactionListLoadingFailure(exception: e));
      } finally {
        event.completer?.complete();
      }
    });
  }
}
