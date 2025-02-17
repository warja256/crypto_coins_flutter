// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_coin_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoCoinDetailsAdapter extends TypeAdapter<CryptoCoinDetails> {
  @override
  final int typeId = 1;

  @override
  CryptoCoinDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CryptoCoinDetails(
      highHour: fields[0] as double,
      lowHour: fields[1] as double,
      priceInUSD: fields[2] as double,
      imageURL: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CryptoCoinDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.highHour)
      ..writeByte(1)
      ..write(obj.lowHour)
      ..writeByte(2)
      ..write(obj.priceInUSD)
      ..writeByte(3)
      ..write(obj.imageURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoCoinDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoCoinDetails _$CryptoCoinDetailsFromJson(Map<String, dynamic> json) =>
    CryptoCoinDetails(
      highHour: (json['HIGH24HOUR'] as num).toDouble(),
      lowHour: (json['LOW24HOUR'] as num).toDouble(),
      priceInUSD: (json['PRICE'] as num).toDouble(),
      imageURL: json['IMAGEURL'] as String,
    );

Map<String, dynamic> _$CryptoCoinDetailsToJson(CryptoCoinDetails instance) =>
    <String, dynamic>{
      'HIGH24HOUR': instance.highHour,
      'LOW24HOUR': instance.lowHour,
      'PRICE': instance.priceInUSD,
      'IMAGEURL': instance.imageURL,
    };
