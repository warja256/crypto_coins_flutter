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
    try {
      final cryptoCoinsList = await _fetchCoinsListFromApi();

      // ПЕРЕКЭШИРОВАНИЕ
      final cryptoCoinsMap = {for (var e in cryptoCoinsList) e.name: e};
      await cryptoCoinsBox.putAll(cryptoCoinsMap);

      return cryptoCoinsList;
    } on Exception catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      // В случае ошибки, возвращаем кешированные данные
      return cryptoCoinsBox.values.toList();
    }
  }

  Future<List<CryptoCoin>> _fetchCoinsListFromApi() async {
    final response = await dio.get(
        'https://min-api.cryptocompare.com/data/top/mktcapfull?limit=50&tsym=USD');

    final data = response.data as Map<String, dynamic>;
    final dataList = data['Data'] as List<dynamic>;
    final cryptoCoinsList = dataList
        .map(
          (e) {
            final coinInfo = e['CoinInfo'] as Map<String, dynamic>;
            final raw = e['RAW']?['USD'] as Map<String, dynamic>?;

            if (raw == null) return null;
            final details = CryptoCoinDetails.fromJson(raw);
            return CryptoCoin(
              name: coinInfo['Name'] as String,
              detail: details,
            );
          },
        )
        .whereType<CryptoCoin>()
        .toList();
    ;
    print('API fetched coins: $cryptoCoinsList');
    return cryptoCoinsList;
  }
}
