import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: GetBuilder(
        init: SplashController(),
        builder: (controller) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("asset/images/splash_icon.png"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  height: 30,
                  width: 70,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("asset/images/title.png"),
                          fit: BoxFit.cover)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}