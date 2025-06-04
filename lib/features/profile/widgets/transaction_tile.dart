import 'package:crypto_coins_flutter/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/models/crypto_coin.dart';
import 'package:crypto_coins_flutter/repositories/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionTileWidget extends StatelessWidget {
  const TransactionTileWidget({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CryptoListBloc, CryptoListState>(
      builder: (context, state) {
        CryptoCoin? matchedCrypto;

        if (state is CryptoListLoaded) {
          try {
            matchedCrypto = state.coinList.firstWhere(
              (crypto) => crypto.name == transaction.cryptoName,
            );
          } catch (e) {
            matchedCrypto = null;
          }
        }
        return Container(
            height: 95,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF232336),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: matchedCrypto != null
                      ? Image.network(
                          matchedCrypto.detail.fullImageUrl,
                          width: 32,
                          height: 32,
                        )
                      : const Icon(Icons.currency_bitcoin, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transaction.type.toString() == 'buy'
                                ? 'Bought ${transaction.cryptoName}'
                                : 'Sold ${transaction.cryptoName}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            transaction.type.toString() == 'buy'
                                ? '+${formatAmount(transaction.amount)} ${transaction.cryptoName}'
                                : '-${formatAmount(transaction.amount)} ${transaction.cryptoName}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        transaction.type.toString() == 'buy'
                            ? '-\$${transaction.totalPrice.toStringAsFixed(2)}'
                            : '+\$${transaction.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${formatDate(transaction.date)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}

String formatDate(DateTime date) {
  final formatter = DateFormat('d MMM y, h.mm a');
  return formatter.format(date);
}

String formatAmount(double amount) {
  String amountStr = amount.toString();
  if (amountStr.contains('.')) {
    final fractionalPart = amountStr.split('.')[1];
    if (fractionalPart.length > 5) {
      return amount.toStringAsFixed(5);
    } else {
      return amountStr;
    }
  } else {
    return amountStr;
  }
}
