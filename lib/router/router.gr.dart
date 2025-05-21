// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [CryptoCoinScreen]
class CryptoCoinRoute extends PageRouteInfo<CryptoCoinRouteArgs> {
  CryptoCoinRoute({
    Key? key,
    required CryptoCoin coin,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
    List<PageRouteInfo>? children,
  }) : super(
          CryptoCoinRoute.name,
          args: CryptoCoinRouteArgs(
            key: key,
            coin: coin,
            isFavorite: isFavorite,
            onFavoriteToggle: onFavoriteToggle,
          ),
          initialChildren: children,
        );

  static const String name = 'CryptoCoinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CryptoCoinRouteArgs>();
      return CryptoCoinScreen(
        key: args.key,
        coin: args.coin,
        isFavorite: args.isFavorite,
        onFavoriteToggle: args.onFavoriteToggle,
      );
    },
  );
}

class CryptoCoinRouteArgs {
  const CryptoCoinRouteArgs({
    this.key,
    required this.coin,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Key? key;

  final CryptoCoin coin;

  final bool isFavorite;

  final VoidCallback onFavoriteToggle;

  @override
  String toString() {
    return 'CryptoCoinRouteArgs{key: $key, coin: $coin, isFavorite: $isFavorite, onFavoriteToggle: $onFavoriteToggle}';
  }
}

/// generated route for
/// [CryptoListScreen]
class CryptoListRoute extends PageRouteInfo<void> {
  const CryptoListRoute({List<PageRouteInfo>? children})
      : super(
          CryptoListRoute.name,
          initialChildren: children,
        );

  static const String name = 'CryptoListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CryptoListScreen();
    },
  );
}

/// generated route for
/// [FavouriteScreen]
class FavouriteRoute extends PageRouteInfo<void> {
  const FavouriteRoute({List<PageRouteInfo>? children})
      : super(
          FavouriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavouriteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavouriteScreen();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}
