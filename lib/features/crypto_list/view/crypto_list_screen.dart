import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_event_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../widgets/crypto_coin_tile.dart';

@RoutePage()
class CryptoListScreen extends StatelessWidget {
  const CryptoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => CryptoListBloc(GetIt.I<AbstractCoinsRepository>())
          ..add(LoadCryptoList(completer: null)),
      ),
    ], child: const _CryptoListView());
  }
}

class _CryptoListView extends StatefulWidget {
  const _CryptoListView();

  @override
  State<_CryptoListView> createState() => _CryptoListViewState();
}

class _CryptoListViewState extends State<_CryptoListView> {
  bool _isSearchVisible = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _cryptoListBloc = context.read<CryptoListBloc>();
    final _favBloc = context.read<FavBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                });
              },
              icon: Icon(Icons.search),
            ),
            SizedBox(
              width: 50,
            ),
            const Text('Crypto Currencies'),
          ],
        ),
        actions: [
          BlocBuilder<ThemeBloc, ThemeStateBloc>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                  icon: Image.asset(
                    state.isDarkTheme
                        ? 'assets/png/dark_mode.png'
                        : 'assets/png/light_mode.png',
                    height: 30,
                  ),
                ),
              );
            },
          ),
        ],
        shadowColor: Theme.of(context).shadowColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final completerCryptoList = Completer();
          final completerFavList = Completer();

          _cryptoListBloc.add(LoadCryptoList(completer: completerCryptoList));
          _favBloc.add(LoadFavList(completer: completerFavList));
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
                  if (_isSearchVisible)
                    Container(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          cursorColor: Theme.of(context).indicatorColor,
                          cursorHeight: 15,
                          onChanged: (text) {
                            setState(() {});
                          },
                          autofocus: true,
                          style: Theme.of(context).textTheme.bodyLarge,
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 20.0, top: 5.0, right: 10.0, bottom: 5.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),

                            // Граница при фокусе
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).indicatorColor,
                                  width: 1.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Search',
                            hintStyle: Theme.of(context).textTheme.bodySmall,

                            focusColor: Theme.of(context).shadowColor,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: filteredList.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.separated(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: filteredList.length,
                            separatorBuilder: (_, __) =>
                                Divider(color: Theme.of(context).dividerColor),
                            itemBuilder: (context, i) {
                              final coin = filteredList[i];
                              return CryptoCoinTile(
                                coin: coin,
                                onFavoriteToggle: () {
                                  final isFavorite = context
                                          .read<FavBloc>()
                                          .state is FavListLoaded &&
                                      (context.read<FavBloc>().state
                                              as FavListLoaded)
                                          .favCoinList
                                          .contains(coin);
                                  if (isFavorite) {
                                    context
                                        .read<FavBloc>()
                                        .add(RemoveFromFav(coin: coin));
                                  } else {
                                    context
                                        .read<FavBloc>()
                                        .add(AddToFav(coin: coin));
                                  }
                                },
                              );
                            },
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
