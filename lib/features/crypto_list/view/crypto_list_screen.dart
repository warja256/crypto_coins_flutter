import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:crypto_coins_flutter/features/crypto_list/widgets/app_bar.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/crypto_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../widgets/crypto_coin_tile.dart';

@RoutePage()
class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListViewState();
}

class _CryptoListViewState extends State<CryptoListScreen> {
  bool _isSearchVisible = true;
  TextEditingController _searchController = TextEditingController();
  int? _userId;
  late final CryptoCoinsRepository cryptoCoinsRepository;

  @override
  void initState() {
    super.initState();
    cryptoCoinsRepository =
        GetIt.I<AbstractCoinsRepository>() as CryptoCoinsRepository;

    _searchController.addListener(() {
      setState(() {});
    });
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final user = await AuthService.getProfile();
    setState(() {
      _userId = user.userId;
    });
  }

  Widget build(BuildContext context) {
    final _cryptoListBloc = context.read<CryptoListBloc>();

    return BlocProvider(
      create: (_) => FavBloc(_userId, cryptoCoinsRepository)
        ..add(LoadFavList(completer: null)),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            final completerCryptoList = Completer();
            final completerFavList = Completer();

            _cryptoListBloc.add(LoadCryptoList(completer: completerCryptoList));
            context
                .read<FavBloc>()
                .add(LoadFavList(completer: completerFavList));
            await Future.wait(
                [completerCryptoList.future, completerFavList.future]);
          },
          child: BlocBuilder<CryptoListBloc, CryptoListState>(
            builder: (context, state) {
              if (state is CryptoListLoaded) {
                List<CryptoCoin> filteredList = state.coinList;
                if (_isSearchVisible) {
                  filteredList = state.coinList
                      .where((coin) => coin.name.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          ))
                      .toList();
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 21,
                    ),
                    CustomAppBar(
                      controller: _searchController,
                      title: 'Watchlist',
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: filteredList.isEmpty
                            ? const Center(child: Text('No results found'))
                            : ListView.separated(
                                padding: const EdgeInsets.only(top: 16),
                                itemCount: filteredList.length,
                                separatorBuilder: (_, __) => SizedBox(
                                  height: 16,
                                ),
                                itemBuilder: (context, i) {
                                  final coin = filteredList[i];
                                  return CryptoCoinTile(
                                    coin: coin,
                                    onFavoriteToggle: () {
                                      final completer = Completer();
                                      final isFavorite = context
                                              .read<FavBloc>()
                                              .state is FavListLoaded &&
                                          (context.read<FavBloc>().state
                                                  as FavListLoaded)
                                              .favCoinList
                                              .contains(coin);
                                      if (isFavorite) {
                                        context.read<FavBloc>().add(
                                            RemoveFromFav(completer,
                                                coin: coin));
                                      } else {
                                        context.read<FavBloc>().add(
                                            AddToFav(completer, coin: coin));
                                      }
                                      context
                                          .read<FavBloc>()
                                          .add(LoadFavList());
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              }
              if (state is CryptoListLoadingFailure) {
                return _ErrorView(retry: () {
                  _cryptoListBloc.add(LoadCryptoList(completer: null));
                });
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback retry;
  const _ErrorView({required this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Please try again later',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(fontSize: 16, color: Colors.white54),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: retry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
