import 'package:get/get.dart';


import '../widgets/bottomnavigationbar.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    splashOn();
    super.onInit();
  }

  Future splashOn() async {
    await Future.delayed(const Duration(seconds: 2));

    Get.offAll(() => BottomNaviBar(), transition: Transition.rightToLeft);
  }
}