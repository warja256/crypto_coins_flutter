import 'package:crypto_coins_flutter/core/transaction_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/create_transaction/transaction_create_event.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/create_transaction/transaction_create_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCreateBloc
    extends Bloc<TransactionCreateEvent, TransactionCreateState> {
  TransactionCreateBloc() : super(TransactionInitial()) {
    on<CreateTransaction>((event, emit) async {
      try {
        emit(TransactionCreating());
        final success = await TransactionService.createTransaction(
            event.userId,
            event.cryptoName,
            event.currency,
            event.amount,
            event.type,
            event.totalPrice,
            event.rate,
            event.date);
        if (success) {
          emit(TransactionCreated());
        } else {
          emit(
              TransactionCreateError(exception: 'Transaction creation failed'));
        }
      } catch (e) {
        emit(TransactionCreateError(exception: e.toString()));
      }
    });
  }
}
