import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:equatable/equatable.dart';

abstract class FavListState extends Equatable {
  const FavListState();

  @override
  List<Object?> get props => [];
}

class FavListInitial extends FavListState {}

class FavListLoading extends FavListState {}

class FavListLoaded extends FavListState {
  final List<CryptoCoin> favCoinList;

  FavListLoaded({required this.favCoinList});

  @override
  List<Object?> get props => [favCoinList];
}

class FavListLoadingFailure extends FavListState {
  final Object exception;
  const FavListLoadingFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
