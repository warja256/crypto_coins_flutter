# **Crypto Coins Flutter** 🚀

Crypto Coins Flutter is a mobile app built with Flutter that allows users to explore cryptocurrencies 💰, view details about them 📊, and add/remove them to/from their favorites list ❤️. The app utilizes state management with Bloc 🔥, and supports theme switching (dark 🌙 and light 🌞 modes).

## **Features** ✨

- **List of Cryptocurrencies**: View a list of cryptocurrencies fetched from an API 📈.
- **Favorites**: Add cryptocurrencies to your favorites list and manage them ❤️.
- **Search**: Search for cryptocurrencies by their names 🔍.
- **Dark/Light Mode**: Switch between dark and light themes 🌚/🌞.
- **Refresh**: Pull to refresh the list of cryptocurrencies and favorites 🔄.

## **Installation** ⚙️

Clone the repository:

```bash
https://github.com/warja256/crypto_coins_flutter.git
```

Navigate to the project directory:
```bash
cd crypto_coins_flutter
```

Install dependencies:
```bash
flutter pub get
```

Run the app:
```bash
flutter run
```

## **Architecture** 🏗️

The project follows the Bloc pattern for state management. The main components include:

**CryptoListBloc**: Manages the state of the cryptocurrency list 📈.

**FavBloc**: Manages the state of the favorites list ❤️.

**ThemeBloc**: Manages the app's theme (dark/light mode) 🌙/🌞.