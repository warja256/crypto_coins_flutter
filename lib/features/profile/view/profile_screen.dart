import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/profile/widgets/balance.dart';
import 'package:crypto_coins_flutter/features/profile/widgets/log_out.dart';
import 'package:crypto_coins_flutter/features/profile/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16171A),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 11,
            ),
            FutureBuilder(
                future: AuthService.getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No user data');
                  } else {
                    final user = snapshot.data;
                    return BalanceWidget(
                      user: user,
                    );
                  }
                }),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Text(
                'Transactions',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(),
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (_, __) {
                    return TransactionTileWidget();
                  },
                  separatorBuilder: (_, __) => SizedBox(
                        height: 16,
                      ),
                  itemCount: 2),
            )),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: LogOutWidget(),
      ),
    );
  }
}
