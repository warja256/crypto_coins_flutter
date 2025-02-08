import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'crypto_coins_list_app.dart';
import 'repositories/crypto_coins/crypto_coin.dart';

void main() {
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker started...');

  final dio = Dio();
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        printResponseData: false,
      ),
    ),
  );

  GetIt.I.registerLazySingleton<AbstractCoinsRepository>(
      () => CryptoCoinsRepository(dio: dio));

  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runZonedGuarded(() => runApp(const CryptoCurrenciesApp()),
      (e, st) => GetIt.I<Talker>().handle(e, st));
}
