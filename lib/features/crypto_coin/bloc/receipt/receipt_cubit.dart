import 'package:crypto_coins_flutter/core/auth_service.dart';
import 'package:crypto_coins_flutter/core/receipt_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_state.dart';
import 'package:crypto_coins_flutter/repositories/models/receipt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  int? _lastReceiptId;

  int? get lastReceiptId => _lastReceiptId;

  ReceiptCubit() : super(ReceiptInitial());

  Future<void> createReceipt(Receipt data) async {
    emit(ReceiptCreating());
    talker.debug('Creating receipt with data: ${data.toJson()}');
    try {
      final receiptId = await ReceiptService.createReceiptFront(
        data.userId,
        data.transactionId,
        data.type,
        data.currency,
        data.email,
        data.date,
        data.filePath,
      );

      talker.debug('ReceiptService returned receiptId: $receiptId');
      if (receiptId != null && receiptId > 0) {
        _lastReceiptId = receiptId;
        talker.info('Emitting ReceiptCreated with receiptId: $receiptId');
        emit(ReceiptCreated(receiptId: receiptId));
      } else {
        final errorMsg =
            'Failed to create receipt: Invalid receiptId ($receiptId)';
        talker.error(errorMsg);
        emit(ReceiptError(exception: errorMsg));
      }
    } catch (e) {
      final errorMsg = 'Failed to create receipt: $e';
      talker.error(errorMsg);
      emit(ReceiptError(exception: errorMsg));
    }
  }

  Future<void> downloadReceipt(int receiptId) async {
    talker.debug('Starting downloadReceipt with receiptId: $receiptId');
    emit(ReceiptDownloading());
    try {
      final result = await ReceiptService.downloadReceiptFront(receiptId);
      if (!result.startsWith('Error')) {
        emit(ReceiptDownloaded(filePath: result));
        talker.debug('✅ Receipt downloaded successfully to $result');
      } else {
        emit(ReceiptError(exception: result));
        talker.error('❌ Failed to download receipt: $result');
      }
    } catch (e) {
      final errorMsg = 'Error downloading receipt: $e';
      talker.error(errorMsg);
      emit(ReceiptError(exception: errorMsg));
    }
  }
}
