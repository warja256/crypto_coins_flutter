part of 'crypto_list_bloc.dart';

abstract class CryptoListState extends Equatable {
  const CryptoListState();

  @override
  List<Object?> get props => [];
}

class CryptoListInitial extends CryptoListState {}

class CryptoListLoading extends CryptoListState {}

class CryptoListLoaded extends CryptoListState {
  final List<CryptoCoin> coinList;
  const CryptoListLoaded({required this.coinList});

  @override
  List<Object?> get props => [coinList];
}

class CryptoListLoadingFailure extends CryptoListState {
  final Object exception;
  const CryptoListLoadingFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
