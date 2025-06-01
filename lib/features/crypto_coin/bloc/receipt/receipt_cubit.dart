import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/core/receipt_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_state.dart';
import 'package:crypto_coins_flutter/repositories/models/receipt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  ReceiptCubit() : super(ReceiptInitial());

  Future<void> createReceipt(Receipt data) async {
    emit(ReceiptCreating());
    final success = await ReceiptService.createReceipt(
      data.userId,
      data.transactionId,
      data.type,
      data.currency,
      data.email,
      data.date,
      data.filePath,
    );
    if (success) {
      emit(ReceiptCreated());
      talker.debug('Receipt created successfully');
    } else {
      emit(ReceiptError(exception: "Failed to create receipt"));
      talker.error('Receipt not created successfully');
    }
  }

  Future<void> downloadReceipt(String receiptId) async {
    emit(ReceiptDownloading());
    final result = await ReceiptService.downloadReceipt(receiptId);
    if (result.startsWith('Error')) {
      emit(ReceiptError(exception: result));
      talker.debug('Receipt not downloaded successfully');
    } else {
      emit(ReceiptDownloaded(filePath: result));
      talker.debug('Receipt downloaded successfully');
    }
  }
}
