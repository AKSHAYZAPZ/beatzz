import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final themeData = GetStorage();

  bool isDarkMode = true;

  String textTheme = 'Dark Theme';
  bool notificationSwitch = false;
  final switchData = GetStorage();

  @override
  void themeChange() {
    isDarkMode = !isDarkMode;
    if (isDarkMode) {
      textTheme = 'Dark Theme';
      themeData.write('theme', isDarkMode);
      Get.changeTheme(
        ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade300,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.red,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red.shade900,
            foregroundColor: Colors.white,
          ),
        ),
      );
    } else {
      textTheme = 'Light Theme';
      Get.changeTheme(ThemeData.dark());
      themeData.write('theme', !isDarkMode);
    }
    update();
  }

  @override
  void onInit() {
    if (themeData.read('theme') != null) {
      isDarkMode = themeData.read('theme');
      update();
    }
    if (switchData.read('getXisSwitched') != null) {
      notificationSwitch = switchData.read('getXisSwitched');
      update();
    }

    // TODO: implement onInit
    super.onInit();
  }

  switchChangeState(value) {
    notificationSwitch = value;
    switchData.write('getXisSwitched', notificationSwitch);
    update();
  }
}