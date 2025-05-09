import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/features/favourite/widgets/fav_list_tile.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_event_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_state_bloc.dart'
    show ThemeStateBloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
  bool _isSearchVisible = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.search)),
            SizedBox(
              width: 80,
            ),
            Text('Favourite'),
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
      ),
      body: RefreshIndicator(
        child: BlocBuilder<FavBloc, FavListState>(builder: (context, state) {
          if (state is FavListLoaded) {
            if (state.favCoinList.isEmpty) {
              return const Center(
                child: Text('No favorite coins'),
              );
            }
            List<CryptoCoin> filteredList = state.favCoinList;
            if (_isSearchVisible) {
              filteredList = state.favCoinList
                  .where((coin) => coin.name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
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
                        onChanged: (text) {
                          setState(() {});
                        },
                        style: Theme.of(context).textTheme.bodySmall,
                        controller: _searchController,
                        decoration: InputDecoration(
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
                          itemBuilder: (context, i) {
                            final favCoin = filteredList[i];
                            return FavListTile(
                              favCoin: favCoin,
                              onFavoriteToggle: () {
                                final isFavorite = context.read<FavBloc>().state
                                        is FavListLoaded &&
                                    (context.read<FavBloc>().state
                                            as FavListLoaded)
                                        .favCoinList
                                        .contains(favCoin);
                                if (isFavorite) {
                                  context
                                      .read<FavBloc>()
                                      .add(RemoveFromFav(coin: favCoin));
                                } else {
                                  context
                                      .read<FavBloc>()
                                      .add(AddToFav(coin: favCoin));
                                }
                              },
                            );
                          },
                          separatorBuilder: (_, __) => Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          itemCount: filteredList.length,
                        ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        }),
        onRefresh: () async {
          final completer = Completer();
          _favBloc.add(LoadFavList(completer: completer));
        },
      ),
    );
  }
}
