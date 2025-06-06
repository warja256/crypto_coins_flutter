import 'package:crypto_coins_flutter/core/favorite_service.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/crypto_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FavBloc extends Bloc<FavEvent, FavListState> {
  final int? userId;
  final AbstractCoinsRepository cryptoCoinsRepository;
  FavBloc(this.userId, this.cryptoCoinsRepository) : super(FavListInitial()) {
    on<LoadFavList>((event, emit) async {
      try {
        emit(FavListLoading());
        final favorites =
            await FavoriteService.loadFavoritesCrypto(userId.toString());

        List<CryptoCoin> favCoins = [];
        for (var fav in favorites) {
          final details =
              await cryptoCoinsRepository.getCoinDetailsByName(fav.cryptoName);
          if (details != null) {
            favCoins.add(CryptoCoin(name: fav.cryptoName, detail: details));
          } else {
            favCoins.add(CryptoCoin(
              name: fav.cryptoName,
              detail: CryptoCoinDetails(
                  highHour: 0, lowHour: 0, priceInUSD: 0, imageURL: ''),
            ));
          }
        }
        emit(FavListLoaded(favCoinList: favCoins));
      } catch (e, st) {
        GetIt.I<Talker>().error('Ошибка загрузка избранных монет');
        emit(FavListLoadingFailure(exception: e));
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    on<AddToFav>(
      (event, emit) async {
        try {
          final result =
              await FavoriteService.addToFavCrypto(userId!, event.coin.name);
          if (result) {
            GetIt.I<Talker>()
                .debug('✅ Монета добавлена в избранное: ${event.coin.name}');
            add(LoadFavList(completer: event.completer));
          } else {
            GetIt.I<Talker>().error('❌ Не удалось добавить монету в избранное');
          }
        } catch (e, st) {
          GetIt.I<Talker>().handle(e, st);
          emit(FavListLoadingFailure(exception: e));
          event.completer?.completeError(e);
        }
      },
    );

    on<RemoveFromFav>(
      (event, emit) async {
        try {
          final result = await FavoriteService.removeFromFavCrypto(
              userId!, event.coin.name);
          if (result) {
            GetIt.I<Talker>()
                .debug('✅ Монета добавлена в избранное: ${event.coin.name}');
            add(LoadFavList(completer: event.completer));
          } else {
            GetIt.I<Talker>().error('❌ Не удалось добавить монету в избранное');
          }
        } catch (e, st) {
          GetIt.I<Talker>().handle(e, st);
          emit(FavListLoadingFailure(exception: e));
          event.completer?.completeError(e);
        }
      },
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
