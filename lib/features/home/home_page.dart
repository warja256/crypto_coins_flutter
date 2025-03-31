// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        CryptoListRoute(),
        FavouriteRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return SafeArea(
          bottom: false,
          child: Container(
            height: 108,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 32, 32, 32),
                  blurRadius: 10,
                  offset: Offset(0, -3),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: BottomNavigationBar(
                selectedIconTheme: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedIconTheme,
                unselectedIconTheme: Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedIconTheme,
                currentIndex: tabsRouter.activeIndex,
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                onTap: tabsRouter.setActiveIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabsRouter.activeIndex == 0
                          ? 'assets/png/crypto_selected.png'
                          : 'assets/png/crypto_unselected.png',
                      width: 40,
                      height: 40,
                    ),
                    label: '', // Добавлен текст
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      tabsRouter.activeIndex == 1
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      size: 35,
                    ),
                    label: '', // Добавлен текст
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
