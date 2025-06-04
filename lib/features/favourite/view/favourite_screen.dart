import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/crypto_list/widgets/app_bar.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/features/favourite/widgets/fav_list_tile.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/crypto_coins_repository.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

@RoutePage()
class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FavouriteScreenView();
  }
}

class _FavouriteScreenView extends StatefulWidget {
  const _FavouriteScreenView();

  @override
  State<_FavouriteScreenView> createState() => _FavouriteScreenViewState();
}

class _FavouriteScreenViewState extends State<_FavouriteScreenView> {
  TextEditingController _searchController = TextEditingController();
  int? _userId;
  bool _isUserLoaded = false;
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
      _isUserLoaded = true;
    });
  }

  Widget build(BuildContext context) {
    if (!_isUserLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    return BlocProvider(
      create: (_) => FavBloc(_userId, cryptoCoinsRepository)
        ..add(LoadFavList(completer: null)),
      child: Scaffold(
        body: RefreshIndicator(
          child: BlocBuilder<FavBloc, FavListState>(builder: (context, state) {
            if (state is FavListLoaded) {
              if (state.favCoinList.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 21,
                    ),
                    CustomAppBar(
                      controller: _searchController,
                      title: 'FavList',
                    ),
                    Spacer(),
                    Text('No favorite coins'),
                    Spacer()
                  ],
                );
              }
              List<CryptoCoin> filteredList = state.favCoinList;
              filteredList = state.favCoinList
                  .where((coin) => coin.name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();

              return Column(
                children: [
                  SizedBox(
                    height: 21,
                  ),
                  CustomAppBar(
                    controller: _searchController,
                    title: 'FavList',
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: filteredList.isEmpty
                          ? const Center(child: Text('No results found'))
                          : ListView.separated(
                              padding: const EdgeInsets.only(top: 16),
                              itemBuilder: (context, i) {
                                final favCoin = filteredList[i];
                                return FavListTile(
                                  favCoin: favCoin,
                                  onFavoriteToggle: () {
                                    final completer = Completer();
                                    final isFavorite = context
                                            .read<FavBloc>()
                                            .state is FavListLoaded &&
                                        (context.read<FavBloc>().state
                                                as FavListLoaded)
                                            .favCoinList
                                            .contains(favCoin);
                                    if (isFavorite) {
                                      context.read<FavBloc>().add(RemoveFromFav(
                                          completer,
                                          coin: favCoin));
                                    } else {
                                      context.read<FavBloc>().add(
                                          AddToFav(completer, coin: favCoin));
                                    }
                                    context.read<FavBloc>().add(LoadFavList());
                                  },
                                );
                              },
                              separatorBuilder: (_, __) => SizedBox(
                                height: 16,
                              ),
                              itemCount: filteredList.length,
                            ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
          onRefresh: () async {
            final completer = Completer();
            context.read<FavBloc>().add(LoadFavList(completer: completer));
          },
        ),
      ),
    );
  }
}
