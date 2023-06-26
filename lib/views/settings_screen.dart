import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts.dart';
import '../controllers/setting_controller.dart';
import '../privacy_policy.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsController = Get.put(SettingsController());
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: scColor,
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Settings',
            ),
            centerTitle: true,
            backgroundColor: scColor),
        body: Column(
          children: [
            buildAbout(context),
            buildTerms(title: 'Terms and Conditions', context: context),
            buildPrivacy(title: 'Privacy Policy', context: context),
            buildNotificationSwitch(),
            buildShare(context),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Version',
                  style: TextStyle(
                      letterSpacing: 1, fontSize: 17, color: textColor),
                ),
                Text(
                  '1.0.0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: textColor),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  buildAbout(context) {
    return ListTile(
      title: const Text(
        'About',
        style: TextStyle(color: textColor),
      ),
      onTap: () => Get.to(
        Theme(
          data: Theme.of(context).copyWith(
              textTheme:
                  const TextTheme(labelSmall: TextStyle(color: Colors.white54)),
              cardColor: const Color.fromARGB(195, 44, 105, 134),
              appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(195, 44, 105, 134),
                  elevation: 0),
              scaffoldBackgroundColor: const Color.fromARGB(195, 44, 105, 134)),
          child: const LicensePage(
            applicationName: 'Beatzz',
            applicationVersion: '1.0.0',
          ),
        ),
      ),
    );
  }

  buildTerms(
      {required String title, Icon? icon, required BuildContext context}) {
    return ListTile(
        title: Text(title, style: const TextStyle(color: textColor)),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
          child: icon,
        ),
        onTap: () {
          Get.to(() => const TermsAndConditions());
        });
  }

  buildPrivacy(
      {required String title, Icon? icon, required BuildContext context}) {
    return ListTile(
        title: Text(title, style: const TextStyle(color: textColor)),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
          child: icon,
        ),
        onTap: () {
          Get.to(() => const PrivacyPolicy());
        });
  }

  buildNotificationSwitch() {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        return SwitchListTile(
          title: const Text('Notification', style: TextStyle(color: textColor)),
          value: controller.notificationSwitch,
          onChanged: (value) {
            controller.switchChangeState(value);
          },
        );
      },
    );
  }

  buildShare(context) {
    return ListTile(
      title: const Text('Share App', style: TextStyle(color: textColor)),
      trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
          child: const SizedBox(
            child: Icon(
              Icons.share,
              color: textColor,
            ),
          )),
      onTap: () async {},
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: scColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: scColor,
            title: const Text("Privacy Policy"),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: privacyPolicy,
          ))),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: scColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: scColor,
            title: const Text("Terms And conditions"),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: termsAndConditions,
          ))),
    );
  }
}