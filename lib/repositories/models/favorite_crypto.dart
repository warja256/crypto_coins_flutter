class FavoriteCrypto {
  final int id;
  final int userId;
  final String cryptoName;

  FavoriteCrypto({
    required this.id,
    required this.userId,
    required this.cryptoName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'crypto_name': cryptoName,
  };

  factory FavoriteCrypto.fromJson(Map<String, dynamic> json) {
    return FavoriteCrypto(
      id: json['id'],
      userId: json['user_id'],
      cryptoName: json['crypto_name'],
    );
  }
}
