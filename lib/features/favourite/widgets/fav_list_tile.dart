import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FavListTile extends StatelessWidget {
  const FavListTile(
      {super.key, required this.favCoin, required this.onFavoriteToggle});

  final CryptoCoin favCoin;
  final VoidCallback onFavoriteToggle;
  final isFavorite = true;

  @override
  Widget build(BuildContext context) {
    final talker = Talker();
    return BlocBuilder<FavBloc, FavListState>(
      builder: (context, state) {
        if (state is FavListLoaded) {}
        return Column(
          children: [
            ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      final favBloc = context.read<FavBloc>();

                      if (isFavorite) {
                        favBloc.add(RemoveFromFav(coin: favCoin));
                      } else {
                        favBloc.add(AddToFav(coin: favCoin));
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  favCoin.detail.imageURL != null
                      ? Image.network(favCoin.detail.fullImageUrl)
                      : CircularProgressIndicator(),
                ],
              ),
              title: Text(favCoin.name,
                  style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text(
                '${favCoin.detail.priceInUSD} \$',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onTap: () {
                talker.log(
                    'Navigating to CryptoCoinRoute with coin: ${favCoin.name}');
                context.router.push(CryptoCoinRoute(
                    coin: favCoin,
                    isFavorite: isFavorite,
                    onFavoriteToggle: onFavoriteToggle));
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
