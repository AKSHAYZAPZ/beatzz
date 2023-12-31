import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistSongAddController extends GetxController {
  final OnAudioRoom audioRoom = OnAudioRoom();

  songAddingPlaylist(
      {required int index,
      required int playListkey,
      required List<SongModel> songs}) {
    audioRoom.addTo(
      RoomType.PLAYLIST,
      songs[index].getMap.toSongEntity(),
      playlistKey: playListkey,
      ignoreDuplicate: false,
    );
    update();
  }

  songDeleteFromPlaylist({
    required int index,
    required int playListKey,
    required List playlistSongs,
  }) async {
    await audioRoom.deleteFrom(
      RoomType.PLAYLIST,
      playlistSongs[index].id,
      playlistKey: playListKey,
    );
    update();
  }
}