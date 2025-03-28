import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/repositories/crypto_coins/crypto_coin.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';

class CryptoCoinTile extends StatelessWidget {
  const CryptoCoinTile({
    super.key,
    required this.coin,
  });

  final CryptoCoin coin;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: coin.detail.imageURL != null
          ? Image.network(coin.detail.fullImageUrl)
          : CircularProgressIndicator(),
      title: Text(coin.name, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(
        '${coin.detail.priceInUSD} \$',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      onTap: () {
        context.router.push(CryptoCoinRoute(coin: coin));
      },
    );
  }
}
