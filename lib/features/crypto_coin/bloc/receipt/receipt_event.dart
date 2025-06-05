abstract class ReceiptCreateEvent {}

class CreateReceipt extends ReceiptCreateEvent {
  final int userId;
  final int transactionId;
  final String type;
  final String currency;
  final String email;
  final DateTime date;
  final String filePath;

  CreateReceipt({
    required this.userId,
    required this.transactionId,
    required this.type,
    required this.currency,
    required this.email,
    required this.date,
    required this.filePath,
  });
}

class DownloadReceipt extends ReceiptCreateEvent {
  final int receiptId;

  DownloadReceipt(this.receiptId);
}
