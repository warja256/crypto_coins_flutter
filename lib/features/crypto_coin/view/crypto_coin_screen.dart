import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_event_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_state_bloc.dart';
import 'package:flutter/material.dart';

import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CryptoCoinScreen extends StatefulWidget {
  final CryptoCoin coin;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  CryptoCoinScreen({
    Key? key,
    required this.coin,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<CryptoCoinScreen> createState() => _CryptoCoinScreenState();
}

class _CryptoCoinScreenState extends State<CryptoCoinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.coin.name,
          style: TextStyle(fontSize: 30),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.network(widget.coin.detail.fullImageUrl, width: 200),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "${widget.coin.detail.priceInUSD.toStringAsFixed(2)} \$",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontSize: 30)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("High 24 Hour",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            "${widget.coin.detail.highHour.toStringAsFixed(2)} \$",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Low 24 Hour",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                            "${widget.coin.detail.lowHour.toStringAsFixed(2)} \$",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<FavBloc, FavListState>(
              builder: (context, state) {
                bool isFavorite = false;
                if (state is FavListLoaded) {
                  isFavorite = state.favCoinList.contains(widget.coin);
                }
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        final favBloc = context.read<FavBloc>();
                        if (isFavorite) {
                          favBloc.add(RemoveFromFav(coin: widget.coin));
                        } else {
                          favBloc.add(AddToFav(coin: widget.coin));
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? Theme.of(context).focusColor
                              : Theme.of(context).hintColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              isFavorite
                                  ? 'В Избранном'
                                  : 'Добавить в избранное',
                              style: TextStyle(
                                color: isFavorite ? Colors.black : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
