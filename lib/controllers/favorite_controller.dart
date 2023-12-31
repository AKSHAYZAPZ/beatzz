import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';

class FavouriteController extends GetxController {
  OnAudioRoom onAudioRoom = OnAudioRoom();
  bool favAdded = false;

  addToFavourite(List songs, int index, bool isAdded) async {
    favAdded = isAdded;
    if (isAdded == false) {
      // Get.back();
      Get.snackbar(
        '',
        '',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        titleText: Text(
          songs[index].title,
          maxLines: 2,
          style: const TextStyle(color: Colors.white),
        ),
        messageText: const Text(
          'Added to Favourite songs',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
      update();
    } else {
      // Get.back();
      Get.snackbar(
        '',
        '',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        titleText: Text(songs[index].title,
            maxLines: 2, style: const TextStyle(color: Colors.white)),
        messageText: const Text(
          'Already added to Favourites',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    update();
  }

  songsDeleteFromFavorites({
    required int index,
    required List favorites,
  }) async {
    await onAudioRoom.deleteFrom(
      RoomType.FAVORITES,
      favorites[index].key,
    );
    update();
  }
}