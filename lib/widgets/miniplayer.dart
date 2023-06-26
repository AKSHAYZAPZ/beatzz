import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../consts.dart';
import '../controllers/home_controller.dart';
import '../controllers/playingscreen_controller.dart';
import '../views/playing_screen.dart';

class BottomMiniPlayer extends StatelessWidget {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId('music');

  final List<Audio> convertedList = [];

  BottomMiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final control = Get.put(PlayingScreenController());

    return assetsAudioPlayer.builderRealtimePlayingInfos(
      builder: (context, realTimeInfo) {
        if (realTimeInfo.current == null) {
          return const Visibility(visible: false, child: CircularProgressIndicator());
        }
        int currentIndex = controller.fechsongsall.indexWhere((element) =>
            element.id.toString() ==
            realTimeInfo.current!.audio.audio.metas.id.toString());

        if (realTimeInfo.isPlaying) {
          control.iconControl.forward();
          control.rotateController.repeat();
        } else {
          control.iconControl.reverse();
          control.rotateController.stop();
        }

        return ListTile(
          horizontalTitleGap: 10,
          leading: buildListTileLeading(
            controller.fechsongsall,
            currentIndex,
            context,
          ),
          title: assetsAudioPlayer.builderRealtimePlayingInfos(
            builder: ((context, realtimePlayingInfos) => realTimeInfo.isPlaying
                ? Text(
                    '${control.assetsAudioPlayer.getCurrentAudioTitle}       ',
                    style: const TextStyle(
                      fontSize: 15,
                      color: textColor,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    control.assetsAudioPlayer.getCurrentAudioTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: textColor,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
          ),
          trailing: assetsAudioPlayer.builderIsPlaying(
            builder: (context, isPlaying) => buildPauseNext(isPlaying),
          ),
          onTap: () {
            Get.to(
              PlayingScreen(
                convertedList: const [],
                index: currentIndex,
                songs: controller.fechsongsall,
              ),
              transition: Transition.downToUp,
            );
          },
        );
      },
    );
  }

// ==================================================================
// Its used to audio next and pause and play.

  Row buildPauseNext(bool isPlaying) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerBuilder.currentPosition(
          player: assetsAudioPlayer,
          builder: (context, duration) {
            return Center(
              child: Text(
                getTimeString(duration.inMilliseconds),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {
            isPlaying ? assetsAudioPlayer.pause() : assetsAudioPlayer.play();
          },
          icon: Icon(
            !isPlaying ? Icons.play_arrow_rounded : Icons.pause_circle,
            color: textColor,
            size: 35,
          ),
        ),
      ],
    );
  }

//===============================================================
  buildListTileLeading(
    image,
    index,
    context,
  ) {
    return QueryArtworkWidget(
      id: image[index].id,
      type: ArtworkType.AUDIO,
      artworkWidth: MediaQuery.of(context).size.width * 0.13,
      artworkHeight: MediaQuery.of(context).size.height * 0.06,
      keepOldArtwork: true,
      nullArtworkWidget: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: scColor,
          image: DecorationImage(
            image: AssetImage(
              'asset/images/music_icon.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.13,
        height: MediaQuery.of(context).size.height * 0.06,
      ),
    );
  }

// ========================================================================================
  // This function is used to convert the song duration to MINUTE AND SECOND

  getTimeString(int milisec) {
    if (milisec == null) milisec = 0;
    String min =
        "${(milisec / 60000).floor() < 10 ? 0 : ''}${(milisec / 60000).floor()}";

    String sec =
        "${(milisec / 1000).floor() % 60 < 10 ? 0 : ''}${(milisec / 1000).floor() % 60}";

    return "$min:$sec";
  }

// ===============================================================================================
}