// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/transaction_create_bloc.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/transaction_create_event.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/transaction_create_state.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/elevated_button_small.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/high_low_price.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/success_widget.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/text_form_amount.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_bloc.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_event.dart';
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
    return BlocProvider(
      create: (context) => TransactionCreateBloc(),
      child: Scaffold(
        backgroundColor: Color(0xFF16171A),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.router.back(),
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xFFA7A7CC),
          ),
          title: Text(
            widget.coin.name,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 22),
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
        body: BlocConsumer<TransactionCreateBloc, TransactionCreateState>(
          listener: (context, state) {
            if (state is TransactionCreated) {
              if (!mounted) return;
              setState(() {
                _isSuccess = true;
              });
              Future.delayed(Duration(seconds: 15), () {
                setState(() {
                  _isSuccess = false;
                });
              });
            } else if (state is TransactionCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.exception.toString())),
              );
            }
          },
          builder: (context, state) {
            return Center(
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
                  HighLowPriceWidget(widget: widget),
                  Column(
                    children: [
                      Visibility(
                        visible: _isSuccess,
                        child: SuccesWidget(),
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
                        TextFormAmountWidget(
                            amountController: amountController),
                        FutureBuilder(
                            future: AuthService.getProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return Text('No user data');
                              } else {
                                final user = snapshot.data;

                                return Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButtonSmall(
                                        onSuccess: () {
                                          final totalPrice = double.tryParse(
                                              amountController.text);
                                          if (totalPrice == null ||
                                              totalPrice <= 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Enter a valid amount greater than 0')),
                                            );
                                            return;
                                          }
                                          final amount = totalPrice /
                                              widget.coin.detail.priceInUSD;
                                          context
                                              .read<TransactionCreateBloc>()
                                              .add(CreateTransaction(
                                                  userId: user!.userId ?? 1,
                                                  cryptoName: widget.coin.name,
                                                  currency: 'USD',
                                                  amount: amount,
                                                  type: 'buy',
                                                  totalPrice: totalPrice,
                                                  rate: widget
                                                      .coin.detail.priceInUSD,
                                                  date: DateTime.now()));
                                          context
                                              .read<TransactionListBloc>()
                                              .add(LoadTransactionList(
                                                  userId:
                                                      snapshot.data!.userId ??
                                                          0));
                                          if (!mounted) return;
                                          setState(() {
                                            _isSuccess = true;
                                            amountController.clear();
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
                                          final totalPrice = double.tryParse(
                                              amountController.text);
                                          if (totalPrice == null ||
                                              totalPrice <= 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Enter a valid amount greater than 0')),
                                            );
                                            return;
                                          }
                                          final amount = totalPrice /
                                              widget.coin.detail.priceInUSD;
                                          context
                                              .read<TransactionCreateBloc>()
                                              .add(CreateTransaction(
                                                  userId: user!.userId ?? 1,
                                                  cryptoName: widget.coin.name,
                                                  currency: 'USD',
                                                  amount: amount,
                                                  type: 'sell',
                                                  totalPrice: totalPrice,
                                                  rate: widget
                                                      .coin.detail.priceInUSD,
                                                  date: DateTime.now()));
                                          context
                                              .read<TransactionListBloc>()
                                              .add(LoadTransactionList(
                                                  userId:
                                                      snapshot.data!.userId ??
                                                          0));
                                          if (!mounted) return;
                                          setState(() {
                                            _isSuccess = true;
                                            amountController.clear();
                                          });
                                        },
                                        amountController: amountController,
                                        title: 'Sell',
                                        color: Color(0xFF3C3C59),
                                      ),
                                    )
                                  ],
                                );
                              }
                            }),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
