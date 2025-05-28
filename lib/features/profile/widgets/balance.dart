// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:crypto_coins_flutter/repositories/user/models/user.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.81, vertical: 21),
        height: 261,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(colors: [
              Color(0xFF6262D9),
              Color(0xFF9D62D9),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Home',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 22),
                ),
                Spacer(),
                Text(
                  'mail:  ${user!.email}',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Color(0xFFD5D5E0)),
                )
              ],
            ),
            SizedBox(
              height: 66.39,
            ),
            Text(
              'Your balance',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 21),
            Text(
              '${user!.balanceCurrency} ${user!.balance}',
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
      ),
    );
  }
}
