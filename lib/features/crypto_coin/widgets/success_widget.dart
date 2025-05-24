import 'package:crypto_coins_flutter/features/crypto_coin/widgets/download_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SuccesWidget extends StatelessWidget {
  const SuccesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Text(
          'Succes!',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        DownloadWidget(),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
