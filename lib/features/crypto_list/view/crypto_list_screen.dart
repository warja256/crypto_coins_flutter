import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
        child: const _CryptoListView(),
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
  @override
  Widget build(BuildContext context) {
    final _cryptoListBloc = context.read<CryptoListBloc>();
    final _favBloc = context.read<FavBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Currencies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(
                    talker: GetIt.I<Talker>(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();
          _cryptoListBloc.add(LoadCryptoList(completer: completer));
          _favBloc.add(LoadFavList(completer: completer));
          await completer.future; // Ожидание загрузки
        },
        child: BlocBuilder<CryptoListBloc, CryptoListState>(
          builder: (context, state) {
            if (state is CryptoListLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemCount: state.coinList.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Theme.of(context).dividerColor),
                itemBuilder: (context, i) {
                  final coin = state.coinList[i];
                  return CryptoCoinTile(
                    coin: coin,
                    onFavoriteToggle: () {
                      final isFavorite =
                          context.read<FavBloc>().state is FavListLoaded &&
                              (context.read<FavBloc>().state as FavListLoaded)
                                  .favCoinList
                                  .contains(coin);
                      if (isFavorite) {
                        context.read<FavBloc>().add(RemoveFromFav(coin: coin));
                      } else {
                        context.read<FavBloc>().add(AddToFav(coin: coin));
                      }
                    },
                  );
                },
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
