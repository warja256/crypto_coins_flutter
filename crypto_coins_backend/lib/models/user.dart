// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final int? userId;
  final String email;
  final String password;
  final double balance;
  final String balanceCurrency;

  User({
    this.userId,
    required this.email,
    required this.password,
    required this.balance,
    required this.balanceCurrency,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'email': email,
    'password': password,
    'balance': balance,
    'balance_currency': balanceCurrency,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['email'] == null ||
        json['password'] == null ||
        json['balance'] == null ||
        json['balance_currency'] == null) {
      throw ArgumentError('Invalid user JSON: missing required fields');
    }
    return User(
      userId: json['user_id'],
      email: json['email'],
      password: json['password'],
      balance: parseToDouble(json['balance']),
      balanceCurrency: json['balance_currency'],
    );
  }
}

double parseToDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
