import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/core/transaction_service.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_event.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  TransactionListBloc() : super(TransactionListInitial()) {
    on<LoadTransactionList>((event, emit) async {
      talker.info('Start loading transactions for userId: ${event.userId}');
      try {
        if (state is! TransactionListLoaded) {
          emit(TransactionListLoading());
        }
        final transactionList =
            await TransactionService.loadTransactions(event.userId.toString());
        emit(TransactionListLoaded(transactionList: transactionList));
        talker.debug(
            'Successfully loaded ${transactionList.length} transactions');
      } catch (e, st) {
        talker.error('Failed to load transactions: $e', e, st);
        emit(TransactionListLoadingFailure(exception: e));
      } finally {
        event.completer?.complete();
        talker.info('Transaction loading process finished');
      }
    });
  }
}
