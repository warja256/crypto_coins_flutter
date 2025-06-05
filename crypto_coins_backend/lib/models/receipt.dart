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
    'date': date.toIso8601String(),
    'file_path': filePath,
  };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    final dateValue = json['date'];
    DateTime parsedDate;
    if (dateValue is String) {
      parsedDate = DateTime.parse(dateValue);
    } else if (dateValue is DateTime) {
      parsedDate = dateValue;
    } else {
      parsedDate = DateTime.now();
    }
    return Receipt(
      receiptId: json['receipt_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      transactionId: json['transaction_id'] ?? 0,
      type: json['type'] ?? 'Unknown',
      currency: json['currency'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      date: parsedDate,
      filePath: json['file_path'] ?? 'Unknown',
    );
  }
}
