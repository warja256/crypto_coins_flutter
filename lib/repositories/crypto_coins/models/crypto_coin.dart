// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CryptoCoin extends Equatable {
  final String name;
  final double priceInUSD;
  final String imageURL;

  CryptoCoin(
      {required this.name, required this.priceInUSD, required this.imageURL});

  @override
  List<Object> get props => [name, priceInUSD, imageURL];
}
