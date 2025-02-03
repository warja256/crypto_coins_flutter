import '../features/crypto_coin/view/view.dart';
import '../features/crypto_list/view/view.dart';

final routes = {
  '/': (context) => CryptoListScreen(),
  '/coin': (context) => CryptoCoinScreen(),
};
