import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/crypto_coin.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

        return Container(
          height: 56,
          decoration: BoxDecoration(
              color: Color(0xFF232336),
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 12, right: 6),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    isFavorite
                        ? 'assets/svg/star_filled.svg'
                        : 'assets/svg/star.svg',
                    color: isFavorite ? null : const Color(0xFFA7A7CC),
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
                const SizedBox(width: 12),
                SizedBox(
                  height: 32,
                  width: 32,
                  child: coin.detail.imageURL.isNotEmpty
                      ? Image.network(coin.detail.fullImageUrl)
                      : CircularProgressIndicator(),
                )
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(coin.name,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 15)),
                Text(
                  '${coin.detail.priceInUSD.toStringAsFixed(2)} \$',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Icon(Icons.arrow_forward_ios,
                  color: Theme.of(context).indicatorColor),
            ),
            onTap: () {
              talker
                  .log('Navigating to CryptoCoinRoute with coin: ${coin.name}');
              context.router.push(CryptoCoinRoute(
                  coin: coin,
                  isFavorite: isFavorite,
                  onFavoriteToggle: onFavoriteToggle));
            },
          ),
        );
      },
    );
  }
}
