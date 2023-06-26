import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beatz_music/views/playing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import '../consts.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/home_controller.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  final List<Audio> convertList = [];

  final OnAudioRoom _audioRoom = OnAudioRoom();

  @override
  Widget build(BuildContext context) {
    Get.put(FavouriteController());
    Get.put(HomeController());

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: scColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("My Favourites"),
          backgroundColor: scColor,
        ),
        body: GetBuilder<FavouriteController>(builder: (_) {
          return FutureBuilder<List<FavoritesEntity>>(
              future: OnAudioRoom().queryFavorites(),
              builder: (context, item) {
                if (item.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (item.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Favourites",
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                List<FavoritesEntity> favorites = item.data!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white12,
                          ),
                          height: MediaQuery.of(context).size.height * 0.09,
                          child: Center(
                            child: ListTile(
                              // =================================================================
                              leading: buildListTileLeading(
                                  favorites, index, context),
                              // ===================================================================
                              title: Text(
                                favorites[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w300),
                              ),
                              // ==================================================================
                              trailing: buildListTileTrailing(
                                favorites,
                                index,
                                context,
                              ),
                              // ================================================================
                              onTap: () {
                                convertAudioFile(favorites);
                                Get.to(
                                  PlayingScreen(
                                    index: index,
                                    convertedList: convertList,
                                    songs:
                                        Get.find<HomeController>().fechsongsall,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
        }),
      ),
    );
  }

  //  ===========================================================================================
  buildListTileLeading(image, index, context) {
    return QueryArtworkWidget(
      id: image[index].id,
      type: ArtworkType.AUDIO,
      artworkWidth: MediaQuery.of(context).size.width * 0.15,
      artworkHeight: MediaQuery.of(context).size.height * 0.14,
      // artworkBorder: BorderRadius.circular(7),
      keepOldArtwork: true,
      // artworkClipBehavior: Clip.none,
      nullArtworkWidget: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scColor,
          image: const DecorationImage(
            image: AssetImage(
              'asset/images/music_icon.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.14,
      ),
    );
  }

  // ==============================================================================
  buildListTileTrailing(favorites, index, BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text("Remove Song ?"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      onPressed: () async {
                        Get.find<FavouriteController>()
                            .songsDeleteFromFavorites(
                                index: index, favorites: favorites);

                        Get.back();
                      },
                      isDefaultAction: true,
                      child: const Text(
                        'Yes',
                        style:
                            TextStyle(color: Color.fromARGB(195, 44, 105, 134)),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Color.fromARGB(206, 133, 54, 69),
                        ),
                      ),
                    )
                  ],
                ));
      },
      icon: const Icon(Icons.remove),
      color: titleColor,
    );
  }

  //===================================================================================
  convertAudioFile(List<FavoritesEntity> favorites) {
    for (var item in favorites) {
      convertList.add(
        Audio.file(
          item.lastData,
          metas: Metas(
            id: item.id.toString(),
            title: item.title,
          ),
        ),
      );
    }
  }
}