import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_coins_flutter/core/receipt_service.dart';
import 'package:crypto_coins_flutter/features/crypto_coin/bloc/receipt/receipt_state.dart';

class ReceiptCreateBloc extends Bloc<ReceiptCreateEvent, ReceiptCreateState> {
  int? _lastReceiptId;

  int? get lastReceiptId => _lastReceiptId;

  ReceiptCreateBloc() : super(ReceiptInitial()) {
    on<CreateReceipt>((event, emit) async {
      try {
        emit(ReceiptCreating());
        final receiptId = await ReceiptService.createReceiptFront(
          event.userId,
          event.transactionId,
          event.type,
          event.currency,
          event.email,
          event.date,
          event.filePath,
        );

        if (receiptId != null && receiptId > 0) {
          _lastReceiptId = receiptId;
          emit(ReceiptCreated(receiptId: receiptId));
        } else {
          emit(ReceiptCreateError(exception: 'Receipt creation failed'));
        }
      } catch (e) {
        emit(ReceiptCreateError(exception: e.toString()));
      }
    });

    on<DownloadReceipt>((event, emit) async {
      try {
        emit(ReceiptDownloading());

        final filePath =
            await ReceiptService.downloadReceiptFront(event.receiptId);

        if (filePath.startsWith('Error:')) {
          emit(ReceiptDownloadError(exception: filePath));
        } else {
          emit(ReceiptDownloaded(filePath: filePath));
        }
      } catch (e) {
        emit(ReceiptDownloadError(exception: e.toString()));
      }
    });
  }
}
