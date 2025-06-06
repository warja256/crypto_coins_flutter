import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_bloc.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          'Success!',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
