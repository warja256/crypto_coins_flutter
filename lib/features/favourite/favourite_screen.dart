import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/features/favourite/widgets/fav_list_tile.dart';
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
  @override
  Widget build(BuildContext context) {
    final _favBloc = context.read<FavBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite'),
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
          child: BlocBuilder<FavBloc, FavListState>(builder: (context, state) {
        if (state is FavListLoaded) {
          if (state.favCoinList.isEmpty) {
            return const Center(
              child: Text('Нет загруженных монет'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, i) {
              final favCoin = state.favCoinList[i];
              return FavListTile(
                favCoin: favCoin,
                onFavoriteToggle: () {
                  final isFavorite =
                      context.read<FavBloc>().state is FavListLoaded &&
                          (context.read<FavBloc>().state as FavListLoaded)
                              .favCoinList
                              .contains(favCoin);
                  if (isFavorite) {
                    context.read<FavBloc>().add(RemoveFromFav(coin: favCoin));
                  } else {
                    context.read<FavBloc>().add(AddToFav(coin: favCoin));
                  }
                },
              );
            },
            separatorBuilder: (_, __) => Divider(
              color: Theme.of(context).dividerColor,
            ),
            itemCount: state.favCoinList.length,
          );
        }
        return const Center(child: CircularProgressIndicator());
      }), onRefresh: () async {
        final completer = Completer();
        _favBloc.add(LoadFavList(completer: completer));
        return completer.future;
      }),
    );
  }
}
