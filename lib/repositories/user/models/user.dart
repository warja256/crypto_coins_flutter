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
    return User(
      userId: json['user_id'],
      email: json['email'],
      password: json['password'],
      balance: json['balance'],
      balanceCurrency: json['balance_currency'],
    );
  }
}
