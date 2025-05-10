class User {
  final int userId;
  final String email;
  final String password;

  User({required this.userId, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'email': email,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      password: json['password'],
    );
  }
}
