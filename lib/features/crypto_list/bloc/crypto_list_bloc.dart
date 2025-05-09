import 'dart:async';
import 'package:crypto_coins_flutter/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'crypto_list_event.dart';
part 'crypto_list_state.dart';

class CryptoListBloc extends Bloc<CryptoListEvent, CryptoListState> {
  CryptoListBloc(this.coinsRepository) : super(CryptoListInitial()) {
    on<LoadCryptoList>((event, emit) async {
      try {
        print("🚀 Загружаем список криптовалют...");
        if (state is! CryptoListLoaded) {
          emit(CryptoListLoading());
        }
        final cryptoCoins = await coinsRepository.getCoinsList();
        print("✅ Загружено: ${cryptoCoins.length} монет, данные: $cryptoCoins");
        emit(CryptoListLoaded(coinList: cryptoCoins));
      } catch (e, st) {
        print("❌ Ошибка при загрузке монет: $e\n$st");
        emit(CryptoListLoadingFailure(exception: e));
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });
  }

  final AbstractCoinsRepository coinsRepository;

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
