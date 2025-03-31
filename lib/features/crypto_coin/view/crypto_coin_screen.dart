import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
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
      appBar: AppBar(title: Text(widget.coin.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.network(widget.coin.detail.fullImageUrl, width: 200),
            const SizedBox(height: 20),
            Text(
              widget.coin.name,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.coin.detail.priceInUSD.toStringAsFixed(2)} \$",
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
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
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("High 24 Hour",
                            style: TextStyle(color: Colors.white)),
                        Text(
                            "${widget.coin.detail.highHour.toStringAsFixed(2)} \$",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Low 24 Hour",
                            style: TextStyle(color: Colors.white)),
                        Text(
                            "${widget.coin.detail.lowHour.toStringAsFixed(2)} \$",
                            style: const TextStyle(color: Colors.white)),
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
                          color: isFavorite ? Colors.white : Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons
                                      .favorite_border, // ✅ Правильный тернарный оператор
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
