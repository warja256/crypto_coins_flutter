import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin_details.dart';
import 'package:equatable/equatable.dart';

class CryptoCoin extends Equatable {
  final String name;
  final CryptoCoinDetails detail;

  const CryptoCoin({
    required this.name,
    required this.detail,
  });

  @override
  List<Object> get props => [name, detail];
}
