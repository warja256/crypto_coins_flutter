// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'crypto_list_bloc.dart';

class CryptoListState {}

class CryptoListInitial extends CryptoListState {}

class CryptoListLoading extends CryptoListState {}

class CryptoListLoaded extends CryptoListState {
  final List<CryptoCoin> coinList;
  CryptoListLoaded({
    required this.coinList,
  });
}

class CryptoListLoadingFailure extends CryptoListState {
  final Object? exception;
  CryptoListLoadingFailure({
    this.exception,
  });
}
