class Transaction {
  final int transactionId;
  final int userId;
  final String cryptoName;
  final String currency;
  final double amount; // 	Кол-во криптовалюты
  final String type;
  final double totalPrice; // 	Сколько реально потрачено/получено
  final double rate; // 	Курс за 1 единицу крипты
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
    'transaction_id': transactionId,
    'user_id': userId,
    'crypto_name': cryptoName,
    'currency': currency,
    'amount': amount,
    'type': type,
    'total_price': totalPrice,
    'rate': rate,
    'date': date.toIso8601String(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      cryptoName: json['crypto_name'] ?? 'Unknown',
      currency: json['currency'] ?? 'Unknown',
      amount: parseToDouble(json['amount']),
      type: json['type'] ?? 'Unknown',
      totalPrice: parseToDouble(json['total_price']),
      rate: parseToDouble(json['rate']),
      date:
          json['date'] is DateTime
              ? json['date']
              : DateTime.parse(json['date']),
    );
  }
}

double parseToDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
