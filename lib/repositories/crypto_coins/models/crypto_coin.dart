import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin_details.dart';

part 'crypto_coin.g.dart';

@HiveType(typeId: 2)
class CryptoCoin extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final CryptoCoinDetails detail;

  const CryptoCoin({
    required this.name,
    required this.detail,
  });

  @override
  List<Object> get props => [name];
}
