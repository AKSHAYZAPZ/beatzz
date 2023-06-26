import 'package:beatz_music/views/song_platlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import '../consts.dart';
import '../controllers/playlist_controller.dart';

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({super.key, this.songs, this.songIndex});
  final OnAudioRoom audioRoom = OnAudioRoom();
  final List<SongModel>? songs;
  final int? songIndex;

  @override
  Widget build(BuildContext context) {
    TextEditingController playListNameController = TextEditingController();
    var playListController = Get.put(PlayListController());
    final formkey = GlobalKey<FormState>();

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text("Playlists"),
            backgroundColor: scColor,
            automaticallyImplyLeading: true,
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: Get.overlayContext!,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text('Create your playlist'),
                          content: Card(
                            color: scColor,
                            elevation: 0.0,
                            child: Column(
                              children: <Widget>[
                                Form(
                                  key: formkey,
                                  child: TextFormField(
                                    controller: playListNameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please enter a name';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Enter a name",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    color: Color.fromARGB(195, 44, 105, 134)),
                              ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  Get.back();

                                  playListController.creatingPlaylistName(
                                      playListNameController.text);
                                  playListNameController.clear();
                                }
                              },
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                Get.back();
                                playListNameController.clear();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  color: Color.fromARGB(206, 133, 54, 69),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          backgroundColor: scColor,
          body: SafeArea(
            child: GetBuilder<PlayListController>(builder: (context) {
              return FutureBuilder<List<PlaylistEntity>>(
                  future: OnAudioRoom().queryPlaylists(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Playlists",
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }
                    List<PlaylistEntity> playlists = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.8),
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if (songs == null) {
                                  return Get.to(() => SongsPlaylist(
                                        playListName:
                                            playlists[index].playlistName,
                                        playListKey: playlists[index].key,
                                      ));
                                } else {
                                  bool isAdded = await audioRoom.checkIn(
                                    RoomType.PLAYLIST,
                                    songs![songIndex!].id,
                                    playlistKey: playlists[index].key,
                                  );

                                  await audioRoom.addTo(
                                    RoomType.PLAYLIST,
                                    songs![songIndex!].getMap.toSongEntity(),
                                    playlistKey: playlists[index].key,
                                    ignoreDuplicate: false,
                                  );

                                  Get.back();
                                  if (isAdded == true) {
                                    Get.snackbar('', '',
                                        duration: const Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM,
                                        titleText: Text(
                                          'Message from ${playlists[index].playlistName}',
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 15, color: textColor),
                                        ),
                                        messageText: Text(
                                          'Song Already Added to ${playlists[index].playlistName}',
                                          maxLines: 2,
                                          style: const TextStyle(color: textColor),
                                        ),
                                        backgroundColor: scColor);
                                  } else {
                                    Get.snackbar('', '',
                                        duration: const Duration(seconds: 2),
                                        snackPosition: SnackPosition.BOTTOM,
                                        titleText: Text(
                                          '${playlists[index].playlistName}',
                                          style: const TextStyle(
                                              fontSize: 15, color: textColor),
                                        ),
                                        messageText: Text(
                                          '${songs![songIndex!].title} Added to ${playlists[index].playlistName} ',
                                          maxLines: 2,
                                          style: TextStyle(color: textColor),
                                        ),
                                        backgroundColor: scColor);
                                  }
                                  Get.to(
                                    () => SongsPlaylist(
                                      playListName:
                                          playlists[index].playlistName,
                                      playListKey: playlists[index].key,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                height: 200,
                                // width: 340,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: GridTile(
                                  footer: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Colors.black54,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              playlists[index].playlistName,
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 20,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context:
                                                        Get.overlayContext!,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CupertinoAlertDialog(
                                                          title: const Text(
                                                              "Delete The Playlist?"),
                                                          actions: <Widget>[
                                                            CupertinoDialogAction(
                                                              onPressed: () {
                                                                playListController
                                                                    .deletePlaylist(
                                                                        playlists[index]
                                                                            .key);
                                                                Get.back();
                                                              },
                                                              isDefaultAction:
                                                                  true,
                                                              child: const Text(
                                                                'Yes',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            195,
                                                                            44,
                                                                            105,
                                                                            134)),
                                                              ),
                                                            ),
                                                            CupertinoDialogAction(
                                                              onPressed: () =>
                                                                  Get.back(),
                                                              child: const Text(
                                                                "No",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          206,
                                                                          133,
                                                                          54,
                                                                          69),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ));
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: titleColor)
                                        ],
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: scColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "asset/images/playlist_cover2.png"),
                                                fit: BoxFit.cover)),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            gradient: LinearGradient(colors: [
                                              Colors.black38,
                                              Colors.black12
                                            ])),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  });
            }),
          )),
    );
  }
}