import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FavBloc extends Bloc<FavEvent, FavListState> {
  final List<CryptoCoin> _favCoinList = [];
  FavBloc() : super(FavListInitial()) {
    on<LoadFavList>((event, emit) async {
      try {
        GetIt.I<Talker>().debug('Загрузка избранных монет');
        emit(FavListLoading());
        emit(FavListLoaded(favCoinList: List.from(_favCoinList)));
      } catch (e, st) {
        GetIt.I<Talker>().error('Ошибка загрузка избранных монет');
        emit(FavListLoadingFailure(exception: e));
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    on<AddToFav>(
      (event, emit) {
        if (!_favCoinList.contains(event.coin)) {
          _favCoinList.add(event.coin);
          GetIt.I<Talker>()
              .debug('Монета добавлена в избранное: ${event.coin.name}');
        }
        emit(FavListLoaded(
            favCoinList: List.from(_favCoinList))); // Обновляем состояние
      },
    );

    on<RemoveFromFav>(
      (event, emit) {
        if (_favCoinList.contains(event.coin)) {
          _favCoinList.remove(event.coin);
          GetIt.I<Talker>()
              .debug('Монета удалена из избранного: ${event.coin.name}');
        }
        emit(FavListLoaded(
            favCoinList: List.from(_favCoinList))); // Обновляем состояние
      },
    );
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
