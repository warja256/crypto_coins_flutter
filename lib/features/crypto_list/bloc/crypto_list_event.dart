// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'crypto_list_bloc.dart';

abstract class CryptoListEvent extends Equatable {}

class LoadCryptoList extends CryptoListEvent {
  final Completer? completer;
  LoadCryptoList({
    required this.completer,
  });

  @override
  List<Object?> get props => [completer];
}
