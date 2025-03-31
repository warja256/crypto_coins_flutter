import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavListTile extends StatelessWidget {
  const FavListTile(
      {super.key, required this.favCoin, required this.onFavoriteToggle});

  final CryptoCoin favCoin;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavBloc, FavListState>(
      builder: (context, FavListState) {
        if (FavListState is FavListLoaded) {}
        return Container();
      },
    );
  }
}
