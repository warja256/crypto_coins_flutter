import 'dart:async';

import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/firebase_options.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin_details.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'crypto_coins_list_app.dart';
import 'repositories/crypto_coins/crypto_coin.dart';
import 'package:hive_flutter/hive_flutter.dart';

const cryptoCoinsBoxName = 'crypto_coins_box';
void main() {
  // Основная функция запуска приложения, обернутая в runZonedGuarded для безопасности
  runZonedGuarded(() async {
    // Убедимся, что Flutter был инициализирован, чтобы использовать библиотеки, такие как Firebase
    WidgetsFlutterBinding.ensureInitialized();

    // Инициализируем Talker для логирования
    final talker = TalkerFlutter.init();
    // Регистрация объекта talker в сервис-локатор GetIt
    GetIt.I.registerSingleton(talker);
    // Логируем запуск Talker
    GetIt.I<Talker>().debug('Talker started...');

    // Инициализируем Hive для хранилища
    await Hive.initFlutter();
    Hive.registerAdapter(CryptoCoinAdapter());
    Hive.registerAdapter(CryptoCoinDetailsAdapter());

    final cryptoCoinsBox = await Hive.openBox<CryptoCoin>(cryptoCoinsBoxName);

    // Инициализация Firebase с использованием настроек для текущей платформы
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Логируем ID проекта Firebase
    talker.info(app.options.projectId);

    // Настройка Dio (HTTP-клиент) с логированием запросов и ответов через Talker
    final dio = Dio();
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker, // Передаем Talker для логирования
        settings: TalkerDioLoggerSettings(
            printResponseData: false), // Настройки логирования
      ),
    );

    // Настройка логирования состояния Bloc с помощью Talker
    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: TalkerBlocLoggerSettings(printStateFullData: false),
    );

    // Регистрация репозитория для работы с криптовалютами в GetIt
    GetIt.I.registerLazySingleton<AbstractCoinsRepository>(
        () => CryptoCoinsRepository(dio: dio, cryptoCoinsBox: cryptoCoinsBox));

    // Настройка обработки ошибок Flutter
    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

    // Запуск главного приложения
    runApp(MultiBlocProvider(providers: [
      BlocProvider(create: (_) => FavBloc()..add(LoadFavList(completer: null)))
    ], child: const CryptoCurrenciesApp()));
  },
      // Обработчик ошибок зоны
      (e, st) => GetIt.I<Talker>().handle(e, st));
}
