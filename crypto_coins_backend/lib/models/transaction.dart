class Transaction {
  final int transactionId;
  final int userId;
  final String cryptoName;
  final String currency;
  final double amount;
  final String type;
  final double totalPrice;
  final double rate;
  final DateTime date;

  Transaction({
    required this.transactionId,
    required this.userId,
    required this.cryptoName,
    required this.currency,
    required this.amount,
    required this.type,
    required this.totalPrice,
    required this.rate,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'userId': userId,
    'cryptoName': cryptoName,
    'currency': currency,
    'amount': amount,
    'type': type,
    'totalPrice': totalPrice,
    'rate': rate,
    'date': date,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      userId: json['userId'],
      cryptoName: json['cryptoName'],
      currency: json['currency'],
      amount: json['amount'],
      type: json['type'],
      totalPrice: json['totalPrice'],
      rate: json['rate'],
      date: json['date'],
    );
  }
}
