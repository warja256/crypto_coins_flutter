import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CryptoCoinsRepository {
  Future<List<CryptoCoin>> getCoinsList() async {
    final response = await Dio().get(
        'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,TON,DOGS,ETH,BNB,PEPE,DAI,VET,CRO&tsyms=USD');

    final data = response.data as Map<String, dynamic>;
    final dataRaw = data['RAW'] as Map<String, dynamic>;
    final cryptoCoinsList = dataRaw.entries.map(
      (e) {
        final USDdata =
            (e.value as Map<String, dynamic>)['USD'] as Map<String, dynamic>;
        final price = USDdata['PRICE'];
        final image = USDdata['IMAGEURL'];
        return CryptoCoin(
            name: e.key,
            priceInUSD: price,
            imageURL: 'https://www.cryptocompare.com/$image');
      },
    ).toList();
    return cryptoCoinsList;
  }
}
