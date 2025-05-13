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
      transactionId: json['transaction_id'],
      userId: json['user_id'],
      cryptoName: json['crypto_name'],
      currency: json['currency'],
      amount: json['amount'],
      type: json['type'],
      totalPrice: json['total_price'],
      rate: json['rate'],
      date: json['date'],
    );
  }
}
