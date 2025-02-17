import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin_details.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'abstract_coins_repository.dart';
import 'models/crypto_coin.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
  CryptoCoinsRepository({
    required this.dio,
    required this.cryptoCoinsBox,
  });

  final Dio dio;
  final Box<CryptoCoin> cryptoCoinsBox;
  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    var cryptoCoinsList = <CryptoCoin>[];
    try {
      final List<CryptoCoin> cryptoCoinsList = await _fetchCoinsListFromApi();

      // ПЕРЕКЭШИРОВАНИЕ
      final cryptoCoinsMap = {for (var e in cryptoCoinsList) e.name: e};
      await cryptoCoinsBox.putAll(cryptoCoinsMap);
    } on Exception catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      return cryptoCoinsBox.values.toList();
    }

    return cryptoCoinsList;
  }

  Future<List<CryptoCoin>> _fetchCoinsListFromApi() async {
    final response = await dio.get(
        'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,TON,DOGS,ETH,BNB,PEPE,DAI,VET,CRO&tsyms=USD');

    final data = response.data as Map<String, dynamic>;
    final dataRaw = data['RAW'] as Map<String, dynamic>;
    final cryptoCoinsList = dataRaw.entries.map(
      (e) {
        final USDdata =
            (e.value as Map<String, dynamic>)['USD'] as Map<String, dynamic>;
        final details = CryptoCoinDetails.fromJson(USDdata);
        return CryptoCoin(
          name: e.key,
          detail: details,
        );
      },
    ).toList();
    return cryptoCoinsList;
  }
}
