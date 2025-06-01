abstract class TransactionCreateEvent {}

class CreateTransaction extends TransactionCreateEvent {
  final int userId;
  final String cryptoName;
  final String currency;
  final double amount;
  final String type;
  final double totalPrice;
  final double rate;
  final DateTime date;

  CreateTransaction(
      {required this.userId,
      required this.cryptoName,
      required this.currency,
      required this.amount,
      required this.type,
      required this.totalPrice,
      required this.rate,
      required this.date});
}
