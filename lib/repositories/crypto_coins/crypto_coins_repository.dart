import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin_details.dart';
import 'package:dio/dio.dart';
import 'abstract_coins_repository.dart';
import 'models/crypto_coin.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
  CryptoCoinsRepository({required this.dio});

  final Dio dio;
  @override
  Future<List<CryptoCoin>> getCoinsList() async {
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
