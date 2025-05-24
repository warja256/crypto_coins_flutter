
import 'package:crypto_coins_flutter/features/crypto_coin/view/crypto_coin_screen.dart';
import 'package:flutter/material.dart';

class HighLowPriceWidget extends StatelessWidget {
  const HighLowPriceWidget({
    super.key,
    required this.widget,
  });

  final CryptoCoinScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        height: 87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                Text("${widget.coin.detail.highHour.toStringAsFixed(2)} \$",
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Low 24 Hour",
                    style: Theme.of(context).textTheme.bodySmall),
                Text("${widget.coin.detail.lowHour.toStringAsFixed(2)} \$",
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
