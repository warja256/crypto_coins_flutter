// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/create_transaction/transaction_create_bloc.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/create_transaction/transaction_create_event.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/create_transaction/transaction_create_state.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_cubit.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_state.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/elevated_button_small.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/high_low_price.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/success_widget.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/widgets/text_form_amount.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_bloc.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_event.dart';
import 'package:crypto_coins_flutter/repositories/models/receipt.dart';
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

  const CryptoCoinScreen({
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
  int? _lastTransactionId;
  String _filePath = '';
  int? receiptId;

  void _handleTransaction({
    required BuildContext context,
    required String type,
    required double totalPrice,
    required double rate,
    required int userId,
    required String email,
  }) {
    final amount = totalPrice / rate;

    context.read<TransactionCreateBloc>().add(
          CreateTransaction(
            userId: userId,
            cryptoName: widget.coin.name,
            currency: 'USD',
            amount: amount,
            type: type,
            totalPrice: totalPrice,
            rate: rate,
            date: DateTime.now(),
          ),
        );

    context.read<TransactionListBloc>().add(
          LoadTransactionList(userId: userId),
        );

    // Defer setting _isSuccess until receipt is created
    context
        .read<TransactionCreateBloc>()
        .stream
        .firstWhere((state) => state is TransactionCreated)
        .then((state) {
      if (state is TransactionCreated) {
        final transactionId =
            context.read<TransactionCreateBloc>().lastTransactionId;
        AuthService.getProfile().then((user) {
          context.read<ReceiptCubit>().createReceipt(
                Receipt(
                  userId: user.userId ?? 0,
                  transactionId: transactionId!,
                  type: type,
                  currency: 'USD',
                  email: user.email,
                  date: DateTime.now(),
                  filePath: '',
                ),
              );
        });
      }
    });

    // Clear the amount controller immediately
    setState(() {
      amountController.clear();
    });
  }

  Widget _buildActionButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButtonSmall(
        title: title,
        color: color,
        amountController: amountController,
        onSuccess: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TransactionCreateBloc()),
        BlocProvider(create: (_) => ReceiptCubit()),
      ],
      child: BlocListener<ReceiptCubit, ReceiptState>(
        listener: (context, state) {
          if (state is ReceiptCreated && state.receiptId != null) {
            receiptId = state.receiptId;
            talker.info('Received new receipt ID: $receiptId');
            setState(() {
              _isSuccess = true;
            });
          } else if (state is ReceiptError) {
            talker.error('Receipt creation failed: ${state.exception}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Failed to create receipt: ${state.exception}')),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF16171A),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA7A7CC)),
              onPressed: () => context.router.back(),
            ),
            title: Text(widget.coin.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 22)),
            actions: [
              BlocBuilder<FavBloc, FavListState>(
                builder: (_, state) {
                  final isFav = state is FavListLoaded &&
                      state.favCoinList.contains(widget.coin);
                  return Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        isFav
                            ? 'assets/svg/star_filled.svg'
                            : 'assets/svg/star.svg',
                        color: isFav ? null : const Color(0xFFA7A7CC),
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        final favBloc = context.read<FavBloc>();
                        favBloc.add(isFav
                            ? RemoveFromFav(coin: widget.coin)
                            : AddToFav(coin: widget.coin));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocConsumer<TransactionCreateBloc, TransactionCreateState>(
            listener: (_, state) {
              if (state is TransactionCreated) {
                final transactionId =
                    context.read<TransactionCreateBloc>().lastTransactionId;
                setState(() {
                  _isSuccess = true;
                  _lastTransactionId = transactionId;
                });

                AuthService.getProfile().then((user) {
                  print('createReceipt called');
                  context.read<ReceiptCubit>().createReceipt(
                        Receipt(
                          userId: user.userId ?? 0,
                          transactionId: transactionId!,
                          type: 'buy',
                          currency: 'USD',
                          email: user.email,
                          date: DateTime.now(),
                          filePath: '',
                        ),
                      );
                });

                Future.delayed(const Duration(seconds: 15), () {
                  if (mounted) {
                    setState(() => _isSuccess = false);
                  }
                });
              }
            },
            builder: (context, _) {
              return Column(
                children: [
                  const SizedBox(height: 44),
                  Image.network(widget.coin.detail.fullImageUrl, width: 150),
                  const SizedBox(height: 27),
                  Text("\$${widget.coin.detail.priceInUSD.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 32),
                  HighLowPriceWidget(widget: widget),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: FutureBuilder(
                      future: AuthService.getProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.hasError) {
                          return Text(
                              snapshot.error?.toString() ?? 'No user data');
                        }

                        final user = snapshot.data!;
                        return BlocBuilder<ReceiptCubit, ReceiptState>(
                          builder: (context, receiptState) {
                            Widget receiptWidget = const SizedBox.shrink();
                            if (_isSuccess && receiptId != null) {
                              receiptWidget =
                                  SuccessWidget(receiptId: receiptId!);
                            } else if (_isSuccess && receiptId == null) {
                              receiptWidget = const Center(
                                  child: CircularProgressIndicator());
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: receiptWidget),
                                Text('Amount',
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                TextFormAmountWidget(
                                    amountController: amountController),
                                Row(
                                  children: [
                                    _buildActionButton(
                                      title: 'Buy',
                                      color: const Color(0xFF6161D6),
                                      onPressed: () {
                                        final totalPrice = double.tryParse(
                                            amountController.text);
                                        if (totalPrice == null ||
                                            totalPrice <= 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Enter a valid amount greater than 0'),
                                            ),
                                          );
                                          return;
                                        }
                                        _handleTransaction(
                                          context: context,
                                          type: 'buy',
                                          totalPrice: totalPrice,
                                          rate: widget.coin.detail.priceInUSD,
                                          userId: user.userId ?? 0,
                                          email: user.email,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 30),
                                    _buildActionButton(
                                      title: 'Sell',
                                      color: const Color(0xFF3C3C59),
                                      onPressed: () {
                                        final totalPrice = double.tryParse(
                                            amountController.text);
                                        if (totalPrice == null ||
                                            totalPrice <= 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Enter a valid amount greater than 0'),
                                            ),
                                          );
                                          return;
                                        }
                                        _handleTransaction(
                                          context: context,
                                          type: 'sell',
                                          totalPrice: totalPrice,
                                          rate: widget.coin.detail.priceInUSD,
                                          userId: user.userId ?? 0,
                                          email: user.email,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 60),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
