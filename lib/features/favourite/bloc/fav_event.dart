import 'dart:async';

import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:equatable/equatable.dart';

abstract class FavEvent extends Equatable {
  // использую Equatable чтобы не хранить одиноковые значения

  const FavEvent(); // конструктор класса

  @override
  List<Object?> get props => []; // определение свойств для сравнения
}

class LoadFavList extends FavEvent {
  final Completer?
      completer; // специальный механизм, который позволяет дождаться выполнения асинхронного действия.
  const LoadFavList({this.completer});
}

class AddToFav extends FavEvent {
  final CryptoCoin coin;
  const AddToFav(this.coin);

  @override
  List<Object?> get props => [coin];
}

class RemoveFromFav extends FavEvent {
  final CryptoCoin coin;
  const RemoveFromFav(this.coin);

  @override
  List<Object?> get props => [coin];
}
