import 'package:beatz_music/consts.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../views/home_screen.dart';
import '../views/settings_screen.dart';
import 'miniplayer.dart';

class BottomNaviBar extends StatelessWidget {
  BottomNaviBar({super.key});
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final pages = [HomeScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: scColor,
          bottomNavigationBar: bottomNavigation(),
          body: SafeArea(
              child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: selectedIndexNotifier,
                    builder: (BuildContext ctx, int updatedIndex, Widget? _) {
                      return pages[updatedIndex];
                    }),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: BottomMiniPlayer(),
              )
            ],
          ))),
    );
  }

  Widget bottomNavigation() {
    return ValueListenableBuilder(
        valueListenable: BottomNaviBar.selectedIndexNotifier,
        builder: (BuildContext ctx, int udatedIndex, Widget? _) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: BottomNavyBar(
                showElevation: false,
                backgroundColor: scColor,
                animationDuration: const Duration(milliseconds: 1000),
                selectedIndex: udatedIndex,
                curve: Curves.bounceOut,
                onItemSelected: (index) {
                  selectedIndexNotifier.value = index;
                },
                itemCornerRadius: 10,
                items: [
                  buildBottomNavyBarItem(const Icon(Icons.home), const Text("Home"),
                      titleColor, const Color.fromARGB(255, 180, 90, 117)),
                  buildBottomNavyBarItem(const Icon(Icons.settings), const Text("Settings"),
                      titleColor, const Color.fromARGB(255, 180, 90, 117)),
                ]),
          );
        });
  }

  buildBottomNavyBarItem(
    Icon icon,
    Text iconName,
    Color activeColor,
    Color inactiveColor,
  ) {
    return BottomNavyBarItem(
      icon: icon,
      title: iconName,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }
}