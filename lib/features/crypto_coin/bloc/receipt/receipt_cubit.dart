import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/core/receipt_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_state.dart';
import 'package:crypto_coins_flutter/repositories/models/receipt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  int? _lastReceiptId;

  int? get lastReceiptId => _lastReceiptId;
  ReceiptCubit() : super(ReceiptInitial());

  Future<void> createReceipt(Receipt data) async {
    emit(ReceiptCreating());
    talker.debug('Creating receipt with data: ${data.toJson()}');
    final receiptId = await ReceiptService.createReceipt(
      data.userId,
      data.transactionId,
      data.type,
      data.currency,
      data.email,
      data.date,
      data.filePath,
    );
    talker.debug('ReceiptService returned receiptId: $receiptId');
    if (receiptId != null && receiptId != 0) {
      talker.info('Emitting ReceiptCreated with receiptId: $receiptId');
      emit(ReceiptCreated(receiptId: receiptId));
      _lastReceiptId = receiptId;
      final filePath = await ReceiptService.downloadReceipt(receiptId);
      if (!filePath.startsWith('Error')) {
        emit(ReceiptDownloaded(filePath: filePath));
        talker.debug('✅ Receipt created and downloaded');
      } else {
        emit(ReceiptError(exception: filePath));
        talker.error('❌ Receipt downloaded with error');
      }
    } else {
      emit(ReceiptError(
          exception: "Failed to create receipt: receiptId is $receiptId"));
      talker.error('❌ Failed to create receipt: receiptId is $receiptId');
    }
  }

  Future<void> downloadReceipt(int receiptId) async {
    if (receiptId == null || receiptId == 'null') {
      talker.error('Invalid receiptId for download: $receiptId');
      emit(ReceiptError(exception: 'Invalid receipt ID'));
      return;
    }
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
