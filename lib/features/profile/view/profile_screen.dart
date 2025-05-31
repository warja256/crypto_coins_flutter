import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_bloc.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_event.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/transaction_list_state.dart';
import 'package:crypto_coins_flutter/features/profile/widgets/balance.dart';
import 'package:crypto_coins_flutter/features/profile/widgets/log_out.dart';
import 'package:crypto_coins_flutter/features/profile/widgets/transaction_tile.dart';
import 'package:crypto_coins_flutter/repositories/models/transaction.dart';
import 'package:crypto_coins_flutter/repositories/user/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = AuthService.getProfile();
    _loadTransactions();
  }

  void _loadTransactions() async {
    final user = await AuthService.getProfile();
    final completerTransactionList = Completer();
    context.read<TransactionListBloc>().add(
          LoadTransactionList(
              userId: user.userId ?? 0, completer: completerTransactionList),
        );
  }

  Widget build(BuildContext context) {
    final _transactionList = context.read<TransactionListBloc>();

    return Scaffold(
      backgroundColor: Color(0xFF16171A),
      body: FutureBuilder(
          future: _userFuture,
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
              return RefreshIndicator(
                onRefresh: () async {
                  final completerTransactionList = Completer();
                  _transactionList.add(LoadTransactionList(
                      userId: user?.userId ?? 0,
                      completer: completerTransactionList));
                  await Future.wait([completerTransactionList.future]);
                },
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 11,
                      ),
                      BalanceWidget(
                        user: user,
                      ),
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
                      BlocBuilder<TransactionListBloc, TransactionListState>(
                        builder: (context, state) {
                          if (state is TransactionListLoaded) {
                            List<Transaction> transactionList =
                                state.transactionList;

                            return Expanded(
                              child: transactionList.isEmpty
                                  ? const Center(
                                      child: Text('No transactions found'))
                                  : ListView.separated(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 24),
                                      itemBuilder: (_, index) {
                                        final transaction =
                                            transactionList[index];
                                        return TransactionTileWidget(
                                          transaction: transaction,
                                        );
                                      },
                                      separatorBuilder: (_, __) => SizedBox(
                                            height: 16,
                                          ),
                                      itemCount: transactionList.length),
                            );
                          } else if (state is TransactionListLoadingFailure) {
                            return Text(state.exception.toString());
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: SafeArea(
        child: LogOutWidget(),
      ),
    );
  }
}
