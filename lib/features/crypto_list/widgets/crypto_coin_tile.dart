import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/crypto_coin.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CryptoCoinTile extends StatelessWidget {
  const CryptoCoinTile({
    super.key,
    required this.coin,
    required this.onFavoriteToggle,
  });

  final CryptoCoin coin;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final talker = Talker();
    return BlocBuilder<FavBloc, FavListState>(
      builder: (context, state) {
        bool isFavorite = false;
        if (state is FavListLoaded) {
          isFavorite = state.favCoinList.contains(coin);
        }

        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  final favBloc = context.read<FavBloc>();

                  if (isFavorite) {
                    favBloc.add(RemoveFromFav(coin: coin));
                  } else {
                    favBloc.add(AddToFav(coin: coin));
                  }
                },
              ),
              const SizedBox(width: 8),
              coin.detail.imageURL != null
                  ? Image.network(coin.detail.fullImageUrl)
                  : CircularProgressIndicator(),
            ],
          ),
          title: Text(coin.name, style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text(
            '${coin.detail.priceInUSD} \$',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
          onTap: () {
            talker.log('Navigating to CryptoCoinRoute with coin: ${coin.name}');
            context.router.push(CryptoCoinRoute(
                coin: coin,
                isFavorite: isFavorite,
                onFavoriteToggle: onFavoriteToggle));
          },
        );
      },
    );
  }
}
