import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beatz_music/views/playing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import '../consts.dart';
import '../controllers/home_controller.dart';
import '../controllers/playlist_songadd_controller.dart';

class SongsPlaylist extends StatelessWidget {
  final dynamic playListName;
  final int playListKey;

  SongsPlaylist({
    Key? key,
    this.playListName,
    required this.playListKey,
  }) : super(key: key);

  final List<Audio> convertedList = [];

  final OnAudioRoom audioRoom = OnAudioRoom();
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    Get.put(PlaylistSongAddController(), permanent: true);

    return GetBuilder<PlaylistSongAddController>(
      builder: (control) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: scColor,
          appBar: AppBar(
            backgroundColor: scColor,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topCenter,
                                colors: searchBgColor)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add songs to ${playListName}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                )
                              ],
                            ),
                            Expanded(
                              child: FutureBuilder<List<SongModel>>(
                                future: audioQuery.querySongs(
                                  sortType: null,
                                ),
                                builder: (context, item) {
                                  if (item.data == null) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (item.data!.isEmpty) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  List<SongModel>? songs = item.data;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListView.builder(
                                      itemCount: songs!.length,
                                      itemBuilder: (context, index) {
                                        return Center(
                                          child: ListTile(
                                            // ================================================================
                                            leading: buildListTileLeading(
                                              songs,
                                              index,
                                              context,
                                            ),

                                            // ================================================================

                                            title: buildListTileTitle(
                                              songs,
                                              index,
                                            ),
                                            subtitle: buildListTileSubTitle(
                                              songs,
                                              index,
                                            ),

                                            // ===================================================================

                                            onTap: () async {
                                              bool isAdded =
                                                  await audioRoom.checkIn(
                                                RoomType.PLAYLIST,
                                                songs[index].id,
                                                playlistKey: playListKey,
                                              );

                                              control.songAddingPlaylist(
                                                index: index,
                                                playListkey: playListKey,
                                                songs: songs,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: scColor,
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded))
            ],
            // automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(playListName),
            centerTitle: true,
          ),
          body: CupertinoScrollbar(
            child: FutureBuilder<List<SongEntity>>(
                future: OnAudioRoom().queryAllFromPlaylist(
                  playListKey,
                  sortType: null,
                ),
                builder: (context, item) {
                  if (item.data == null) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (item.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No songs',
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }

                  List<SongEntity> playlistSongs = item.data!;

                  return ListView.builder(
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
                              leading: buildListTileLeading(
                                  playlistSongs, index, context),
                              title: listTileAudioTitle(playlistSongs, index),
                              trailing: IconButton(
                                onPressed: () async {
                                  control.songDeleteFromPlaylist(
                                      index: index,
                                      playListKey: playListKey,
                                      playlistSongs: playlistSongs);
                                },
                                icon: const Icon(Icons.playlist_remove),
                                color: titleColor,
                                iconSize: 33,
                              ),
                              onTap: () {
                                convertAudioFile(playlistSongs);
                                Get.to(
                                  () => PlayingScreen(
                                    index: index,
                                    convertedList: convertedList,
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
                    itemCount: playlistSongs.length,
                  );
                }),
          ),
        ),
      ),
    );
  }

// =================================================================

// =====================================================================================
  buildListTileLeading(
    image,
    index,
    context,
  ) {
    return QueryArtworkWidget(
      id: image[index].id,
      type: ArtworkType.AUDIO,
      artworkWidth: MediaQuery.of(context).size.width * 0.15,
      artworkHeight: MediaQuery.of(context).size.height * 0.14,
      keepOldArtwork: true,
      nullArtworkWidget: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scColor,
          image: const DecorationImage(
            image: AssetImage("asset/images/music_icon.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.14,
      ),
    );
  }

//=================================================================================
  listTileAudioTitle(List<SongEntity> playListSongs, int index) {
    return Text(
      playListSongs[index].title,
      maxLines: 2,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: textColor,
          fontWeight: FontWeight.w300),
    );
  }

// ==================================================================================
  convertAudioFile(List<SongEntity> playListSongs) {
    for (var item in playListSongs) {
      convertedList.add(
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

  buildListTileTitle(title, index) {
    return Text(
      title[index].title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  buildListTileSubTitle(title, index) {
    return Text(
      title[index].artist,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: subTextColor,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}