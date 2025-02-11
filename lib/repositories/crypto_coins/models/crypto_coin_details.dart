import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_coin_details.g.dart'; // генерируемый файл

@JsonSerializable()
class CryptoCoinDetails extends Equatable {
  const CryptoCoinDetails({
    required this.highHour,
    required this.lowHour,
    required this.priceInUSD,
    required this.imageURL,
  });

  @JsonKey(name: 'HIGH24HOUR')
  final double highHour;
  @JsonKey(name: 'LOW24HOUR')
  final double lowHour;
  @JsonKey(name: 'PRICE')
  final double priceInUSD;
  @JsonKey(name: 'IMAGEURL')
  final String imageURL;

  String get fullImageUrl => 'https://www.cryptocompare.com$imageURL';

  factory CryptoCoinDetails.fromJson(Map<String, dynamic> json) =>
      _$CryptoCoinDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoCoinDetailsToJson(this);

  @override
  List<Object> get props => [
        priceInUSD,
        imageURL,
        highHour,
        lowHour,
      ];
}
