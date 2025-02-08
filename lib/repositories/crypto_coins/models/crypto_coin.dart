import 'package:equatable/equatable.dart';

class CryptoCoin extends Equatable {
  final String name;
  final double priceInUSD;
  final String imageURL;
  final double highHour;
  final double lowHour;

  const CryptoCoin({
    required this.name,
    required this.priceInUSD,
    required this.imageURL,
    required this.highHour,
    required this.lowHour,
  });

  @override
  List<Object> get props => [name, priceInUSD, imageURL, highHour, lowHour];
}
