import 'package:flutter/material.dart';

class TransactionTileWidget extends StatelessWidget {
  const TransactionTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Icon(
              Icons.money_sharp,
              color: Colors.white,
            )),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bought ETH',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '-\$812.10',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '30 Jul 2022, 3.30 PM',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+0.65 ETH',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Spacer(),
              ],
            ),
          ],
        ));
  }
}
