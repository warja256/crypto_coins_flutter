class Receipt {
  final int receiptId;
  final int transactionId;
  final String type;
  final String currency;
  final String email;
  final DateTime date;
  final String filePath;

  Receipt({
    required this.receiptId,
    required this.transactionId,
    required this.type,
    required this.currency,
    required this.email,
    required this.date,
    required this.filePath,
  });

  Map<String, dynamic> toJson() => {
    'receiptId': receiptId,
    'transactionId': transactionId,
    'type': type,
    'currency': currency,
    'email': email,
    'date': date,
    'filePath': filePath,
  };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      receiptId: json['receiptId'],
      transactionId: json['transactionId'],
      type: json['type'],
      currency: json['currency'],
      email: json['email'],
      date: json['date'],
      filePath: json['filePath'],
    );
  }
}
