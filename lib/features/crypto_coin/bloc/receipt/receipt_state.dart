abstract class ReceiptCreateState {}

class ReceiptInitial extends ReceiptCreateState {}

class ReceiptCreating extends ReceiptCreateState {}

class ReceiptCreated extends ReceiptCreateState {
  final int receiptId;

  ReceiptCreated({required this.receiptId});
}

class ReceiptCreateError extends ReceiptCreateState {
  final String exception;

  ReceiptCreateError({required this.exception});
}

class ReceiptDownloading extends ReceiptCreateState {}

class ReceiptDownloaded extends ReceiptCreateState {
  final String filePath;

  ReceiptDownloaded({required this.filePath});
}

class ReceiptDownloadError extends ReceiptCreateState {
  final String exception;

  ReceiptDownloadError({required this.exception});
}
