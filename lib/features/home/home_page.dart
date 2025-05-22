// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:crypto_coins_flutter/router/router.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_bloc.dart';
import 'package:crypto_coins_flutter/theme/bloc/theme_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: BlocBuilder<ThemeBloc, ThemeStateBloc>(
                builder: (context, state) {
                  return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    selectedIconTheme: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedIconTheme,
                    unselectedIconTheme: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedIconTheme,
                    currentIndex: tabsRouter.activeIndex,
                    backgroundColor: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor,
                    selectedLabelStyle: TextStyle(fontSize: 0),
                    unselectedLabelStyle: TextStyle(fontSize: 0),
                    onTap: tabsRouter.setActiveIndex,
                    items: [
                      BottomNavigationBarItem(
                          label: '',
                          icon: Center(
                            child: SvgPicture.asset('assets/svg/home.svg',
                                width: 24,
                                height: 24,
                                color: tabsRouter.activeIndex == 0
                                    ? Color(0xFF7878FA)
                                    : Color(0xFFA7A7CC)),
                          )),
                      BottomNavigationBarItem(
                          label: '',
                          icon: Center(
                            child: SvgPicture.asset('assets/svg/star.svg',
                                width: 24,
                                height: 24,
                                color: tabsRouter.activeIndex == 1
                                    ? Color(0xFF7878FA)
                                    : Color(0xFFA7A7CC)),
                          )),
                      BottomNavigationBarItem(
                        icon: Center(
                          child: SvgPicture.asset('assets/svg/profile.svg',
                              width: 24,
                              height: 24,
                              color: tabsRouter.activeIndex == 2
                                  ? Color(0xFF7878FA)
                                  : Color(0xFFA7A7CC)),
                        ),
                        label: '',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
