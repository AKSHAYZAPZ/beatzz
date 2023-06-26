import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PlayingScreenController extends GetxController
    with GetTickerProviderStateMixin {
  bool repeat = false;
  bool shuffle = false;

  late AnimationController iconControl;
  late AnimationController rotateController;
  late Animation<double> rotateAnimation;
  late AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('music');

  bool notificationSwitch = false;
  final switchData = GetStorage();

  @override
  void onInit([index, List<Audio>? list]) {
    if (list == null) {
      return null;
    }
    if (index == null) {
      return null;
    }

    assetsAudioPlayer.open(
      Playlist(audios: list, startIndex: index),
      autoStart: false,
      showNotification: notificationSwitch,
      loopMode: LoopMode.playlist,
      notificationSettings: NotificationSettings(
        stopEnabled: false,
        customNextAction: (player) {
          if (!iconControl.isCompleted) {
            iconControl.forward();

            rotateController.repeat();
          }
          player.next();
        },
        customPrevAction: (player) {
          if (!iconControl.isCompleted) {
            iconControl.forward();
            assetsAudioPlayer.play();
            rotateController.repeat();
          }
          player.previous();
        },
        customPlayPauseAction: (player) {
          if (!iconControl.isCompleted) {
            iconControl.forward();
            rotateController.repeat();
            player.play();
          } else if (iconControl.isCompleted) {
            iconControl.reverse();
            rotateController.stop();
            player.pause();
          }
        },
      ),
    );

    if (switchData.read('getXisSwitched') != null) {
      notificationSwitch = switchData.read('getXisSwitched');
      update();
    }

    iconControl =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    rotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..stop();

    rotateAnimation =
        CurvedAnimation(parent: rotateController, curve: Curves.easeIn);

    // permission request
    update();
    super.onInit();
  }

  @override
  void onClose() {
    iconControl.dispose();
    rotateController.dispose();
    // assetsAudioPlayer.dispose();
    if (switchData == false) {
      assetsAudioPlayer.dispose();
    }
    super.onClose();
  }

  repeatSong() {
    repeat = !repeat;
    update();
  }

  shuffleSong() {
    shuffle = !shuffle;
    update();
  }

  changingSliderSeek(double sec) {
    Duration pos = Duration(seconds: sec.toInt());
    assetsAudioPlayer.seek(pos);
    update();
  }

  switchChangeState(value) {
    notificationSwitch = value;
    switchData.write('getXisSwitched', notificationSwitch);
    update();
  }
}