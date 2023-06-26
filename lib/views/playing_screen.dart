import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beatz_music/views/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import '../consts.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/playingscreen_controller.dart';
import '../controllers/playlist_controller.dart';

class PlayingScreen extends GetView<PlayingScreenController> {
  final dynamic index;

  final List<Audio>? convertedList;

  final List<SongModel>? songs;

  PlayingScreen({
    Key? key,
    required this.convertedList,
    this.songs,
    this.index,
  }) : super(key: key);

  final OnAudioRoom audioRoom = OnAudioRoom();

  final TextEditingController playListNameController = TextEditingController();
  // var favriteController=  Get.find<FavouriteController>();

  @override
  Widget build(BuildContext context) {
    Get.put(PlayListController());
    Get.put(PlayingScreenController()).onInit(index, convertedList);

    // controller.onInit(index, convertedList);

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black12, Colors.white54],
            )),
          ),
          Scaffold(
            backgroundColor: scColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: scColor,
            ),
            body: SingleChildScrollView(
              child: GetBuilder<PlayingScreenController>(
                builder: (control) => Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            control.assetsAudioPlayer
                                .builderRealtimePlayingInfos(
                              builder: (context, realtimeInfos) {
                                if (realtimeInfos.current == null) {
                                  return const Visibility(
                                      visible: false,
                                      child: CircularProgressIndicator());
                                }
                                //  print(realtimeInfos.current);
                                return RotationTransition(
                                  turns: control.rotateAnimation,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: QueryArtworkWidget(
                                      id: int.parse(
                                        realtimeInfos
                                            .current!.audio.audio.metas.id
                                            .toString(),
                                      ),
                                      type: ArtworkType.AUDIO,
                                      keepOldArtwork: true,
                                      artworkHeight:
                                          MediaQuery.of(context).size.height *
                                              0.34,
                                      artworkWidth:
                                          MediaQuery.of(context).size.height *
                                              0.34,
                                      artworkBorder: BorderRadius.circular(150),
                                      artworkBlendMode: BlendMode.darken,
                                      artworkFit: BoxFit.cover,
                                      nullArtworkWidget: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.34,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.34,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'asset/images/artwork.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            control.assetsAudioPlayer
                                .builderRealtimePlayingInfos(
                                    builder: (context, realtimeInfos) {
                              if (realtimeInfos.current == null) {
                                return const Visibility(
                                    visible: false,
                                    child: CircularProgressIndicator());
                              }
                              return Text(
                                controller
                                    .assetsAudioPlayer.getCurrentAudioTitle,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w300,
                                ),
                              );
                            }),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            buildFavoriteAddandPlaylistAddIcon(context),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            buildSongDuration(context),
                            buildRepeatAndShuffleIcon(context),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            buildPauseAndPlayandFastForwardIcons(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // for add to favorites and   playlist.

  buildFavoriteAddandPlaylistAddIcon(context) {
    return controller.assetsAudioPlayer.builderRealtimePlayingInfos(
        builder: (context, realTimeInfo) {
      if (realTimeInfo.current == null) {
        return const Visibility(
            visible: false, child: CircularProgressIndicator());
      }
      int currentIndex = songs!.indexWhere((element) =>
          element.id.toString() ==
          realTimeInfo.current!.audio.audio.metas.id.toString());

      var check = songs!.where((element) =>
          element.id.toString() ==
          realTimeInfo.current!.audio.audio.metas.id.toString());

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () async {
              // print(check);

              bool isAdded = await audioRoom.checkIn(
                  RoomType.FAVORITES, songs![currentIndex].id);
              audioRoom.addTo(
                RoomType.FAVORITES,
                songs![currentIndex].getMap.toFavoritesEntity(),
                ignoreDuplicate: false,
              );

              Get.find<FavouriteController>()
                  .addToFavourite(songs!, index, isAdded);
            },
            icon: Icon(
              Icons.favorite,
              color: textColor,
              size: 25,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.53,
          ),
          IconButton(
            onPressed: () {
              Get.to(
                PlaylistScreen(songs: songs!, songIndex: currentIndex),
              );
            },
            icon: Icon(
              Icons.playlist_add,
              color: textColor,
              size: 35,
            ),
          ),
        ],
      );
    });
  }

  buildSongDuration(context) {
    return PlayerBuilder.currentPosition(
        player: controller.assetsAudioPlayer,
        builder: (context, duration) {
          if (duration == null) {
            return const Visibility(
              visible: false,
              child: CircularProgressIndicator(),
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                getTimeString(duration.inMilliseconds),
                style: TextStyle(
                  color: textColor,
                ),
              ),
              buildSlider(context),
              controller.assetsAudioPlayer.builderRealtimePlayingInfos(
                  builder: (context, realTimeInfo) {
                if (realTimeInfo.current == null) {
                  return const Visibility(
                      visible: false, child: CircularProgressIndicator());
                }
                return GestureDetector(
                  onTap: () {
                    // print(duration.inMinutes);
                  },
                  child: Text(
                    getTimeString(realTimeInfo.duration.inMilliseconds),
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                );
              })
            ],
          );
        });
  }

  // =====================================================================================
  // This is a Slider widget. Its a seek bar using to audio control and change the duration.

  buildSlider(context) {
    return controller.assetsAudioPlayer.builderRealtimePlayingInfos(
        builder: (context, realTimeInfo) {
      if (realTimeInfo.current == null) {
        return const Visibility(
            visible: false, child: CircularProgressIndicator());
      }
      return GetBuilder<PlayingScreenController>(builder: (controller) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 1.7,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 7,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 7,
            ),
          ),
          child: Expanded(
            child: Slider(
              activeColor: titleColor,
              inactiveColor: textColor,
              value: realTimeInfo.currentPosition.inSeconds.toDouble(),
              min: 0,
              max: realTimeInfo.duration.inSeconds.toDouble() + 1.0,
              onChanged: (value) {
                controller.changingSliderSeek(value.toDouble());
              },
            ),
          ),
        );
      });
    });
  }

  buildRepeatAndShuffleIcon(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GetBuilder<PlayingScreenController>(
          builder: (controller) => IconButton(
            onPressed: () {
              controller.repeatSong();
              if (controller.repeat) {
                controller.assetsAudioPlayer.setLoopMode(LoopMode.single);
              } else {
                controller.assetsAudioPlayer.setLoopMode(LoopMode.none);
              }

              
            },
            icon: Icon(
              Icons.repeat,
              color: controller.repeat
                  ? const Color.fromARGB(255, 3, 37, 71)
                  : textColor,
              size: 30,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.53,
        ),
        GetBuilder<PlayingScreenController>(
          builder: (controller) => IconButton(
            onPressed: () {
              controller.shuffleSong();
              if (controller.shuffle) {
                controller.assetsAudioPlayer.toggleShuffle();
              }
            },
            icon: Icon(
              Icons.shuffle,
              color: controller.shuffle
                  ? const Color.fromARGB(255, 3, 32, 65)
                  : textColor,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  buildPauseAndPlayandFastForwardIcons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.white54, width: 0),
                color: subTextColor),
            child: const Icon(
              Icons.fast_rewind_sharp,
              color: Colors.black,
              size: 30,
            ),
          ),
          onTap: () {
            if (!controller.iconControl.isCompleted) {
              controller.iconControl.forward();
              controller.assetsAudioPlayer.play();
              controller.rotateController.repeat();
            }
            controller.assetsAudioPlayer.previous();
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),

        GestureDetector(
          child: Container(
            height: 60,
            width: 60,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: subTextColor),
            child: Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                color: Colors.black,
                size: 45,
                progress: controller.iconControl,
              ),
            ),
          ),
          onTap: () => onIconPress(),
        ),
        // ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.10,
        ),

        GestureDetector(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.white, width: 2),
                color: subTextColor),
            child: const Center(
              child: Icon(
                Icons.fast_forward_sharp,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          onTap: () {
            if (!controller.iconControl.isCompleted) {
              controller.iconControl.forward();
              controller.rotateController.repeat();
            }
            controller.assetsAudioPlayer.next();
          },
        )
      ],
    );
  }

  void onIconPress() {
    final aniState = controller.iconControl.status;

    if (aniState == AnimationStatus.completed) {
      controller.iconControl.reverse();
      controller.assetsAudioPlayer.playOrPause();
      controller.rotateController.stop();
    } else {
      controller.assetsAudioPlayer.play();
      controller.iconControl.forward();
      controller.rotateController.repeat();
    }
  }

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sec =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sec";
  }
}
