// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:crypto_coins_flutter/features/favourite/bloc/fav_bloc.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_event.dart';
import 'package:crypto_coins_flutter/features/favourite/bloc/fav_state.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';

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
  final amountController = TextEditingController();
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16171A),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.back(),
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xFFA7A7CC),
        ),
        title: Text(
          widget.coin.name,
          style:
              Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 22),
        ),
        actions: [
          BlocBuilder<FavBloc, FavListState>(
            builder: (context, state) {
              bool isFavorite = false;
              if (state is FavListLoaded) {
                isFavorite = state.favCoinList.contains(widget.coin);
              }
              return Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: IconButton(
                  onPressed: () {
                    final favBloc = context.read<FavBloc>();
                    if (isFavorite) {
                      favBloc.add(RemoveFromFav(coin: widget.coin));
                    } else {
                      favBloc.add(AddToFav(coin: widget.coin));
                    }
                    setState(() {});
                  },
                  icon: SvgPicture.asset(
                    isFavorite
                        ? 'assets/svg/star_filled.svg'
                        : 'assets/svg/star.svg',
                    color: isFavorite ? null : const Color(0xFFA7A7CC),
                    height: 24,
                    width: 24,
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
            const SizedBox(height: 44),
            Image.network(widget.coin.detail.fullImageUrl, width: 150),
            const SizedBox(height: 27),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "\$${widget.coin.detail.priceInUSD.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineLarge),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                height: 87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: Color(0xFF232336),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("High 24 Hour",
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            "${widget.coin.detail.highHour.toStringAsFixed(2)} \$",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Low 24 Hour",
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            "${widget.coin.detail.lowHour.toStringAsFixed(2)} \$",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Visibility(
                  visible: _isSuccess,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Succes!',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          shadowColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        ),
                        onPressed: () {},
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFF3C3C59)),
                          child: Container(
                              height: 40,
                              width: 185,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Download receipt',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  SvgPicture.asset(
                                    'assets/svg/download.svg',
                                    width: 15,
                                    height: 15,
                                  )
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                )
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      suffixStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                      suffix: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('\$'),
                      ),
                      errorMaxLines: 1,
                      helperText: ' ',
                      contentPadding: EdgeInsets.all(8),
                      fillColor: Color(0xFF4C4C65),
                      filled: true,
                      hintText: '0.00',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                      suffixIconColor: Color(0xFFE4E4F0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Color(0xFFA7A7CC), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Color(0xFFE4E4F0), width: 1)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Color(0xFFA7A7CC), width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Color(0xFFA7A7CC), width: 1),
                      ),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    cursorColor: Color(0xFFE4E4F0),
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*,?\d*')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonSmall(
                          onSuccess: () {
                            setState(() {
                              _isSuccess = true;
                            });
                          },
                          title: 'Buy',
                          color: Color(0xFF6161D6),
                          amountController: amountController,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: ElevatedButtonSmall(
                          onSuccess: () {
                            setState(() {
                              _isSuccess = true;
                            });
                          },
                          amountController: amountController,
                          title: 'Sell',
                          color: Color(0xFF3C3C59),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ElevatedButtonSmall extends StatefulWidget {
  const ElevatedButtonSmall({
    Key? key,
    required this.title,
    required this.color,
    required this.amountController,
    required this.onSuccess,
  }) : super(key: key);

  final String title;
  final Color color;
  final TextEditingController amountController;
  final VoidCallback onSuccess;

  @override
  State<ElevatedButtonSmall> createState() => _ElevatedButtonSmallState();
}

class _ElevatedButtonSmallState extends State<ElevatedButtonSmall> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {
        if (widget.amountController.text.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Amount is required')));
          return;
        }
        widget.onSuccess();
      },
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: widget.color),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
