// ignore_for_file: public_member_api_docs, sort_constructors_first
class Receipt {
  final int receiptId;
  final int userId;
  final int transactionId;
  final String type;
  final String currency;
  final String email;
  final DateTime date;
  final String filePath;

  Receipt({
    required this.receiptId,
    required this.userId,
    required this.transactionId,
    required this.type,
    required this.currency,
    required this.email,
    required this.date,
    required this.filePath,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'receipt_id': receiptId,
    'transaction_id': transactionId,
    'type': type,
    'currency': currency,
    'email': email,
    'date': date,
    'file_path': filePath,
  };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      receiptId: json['receipt_id'],
      userId: json['user_id'],
      transactionId: json['transaction_id'],
      type: json['type'],
      currency: json['currency'],
      email: json['email'],
      date: json['date'],
      filePath: json['file_path'],
    );
  }
}
