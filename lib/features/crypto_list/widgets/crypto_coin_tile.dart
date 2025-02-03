import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CryptoCoinTile extends StatelessWidget {
  const CryptoCoinTile({
    super.key,
    required this.coinName,
  });

  final String coinName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        'assets/bitcoin.svg',
        width: 40,
        height: 40,
      ),
      title: Text(coinName, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(
        "200000\$",
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/coin',
          arguments: coinName,
        );
      },
    );
  }
}
