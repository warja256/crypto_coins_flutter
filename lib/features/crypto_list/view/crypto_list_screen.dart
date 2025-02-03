import 'package:flutter/material.dart';

import '../widgets/crypto_coin_tile.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({
    super.key,
  });

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Currencies'),
        primary: true,
      ),
      body: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, i) => Divider(
                color: Theme.of(context).dividerColor,
              ),
          itemBuilder: (context, i) {
            const coinName = 'Bitcoin';
            return CryptoCoinTile(coinName: coinName);
          }),
    );
  }
}
