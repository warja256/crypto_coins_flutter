import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_cubit.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    super.key,
    required this.receiptId,
  });
  final int? receiptId;

  @override
  Widget build(BuildContext context) {
    if (receiptId == null) {
      talker.warning('ReceiptId is null in SuccessWidget, download skipped');
      return const SizedBox.shrink();
    }
    return BlocBuilder<ReceiptCubit, ReceiptState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              'Succes!',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: () {
                final id = context.read<ReceiptCubit>().lastReceiptId;
                if (id != null) {
                  context.read<ReceiptCubit>().downloadReceipt(receiptId!);
                } else {
                  talker.warning(
                      'ReceiptId is null in SuccessWidget, download skipped');
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF3C3C59)),
                child: Container(
                    height: 40,
                    width: 185,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Download receipt',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        SvgPicture.asset(
                          'assets/svg/download.svg',
                          width: 15,
                          height: 15,
                        )
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        );
      },
    );
  }
}
