import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beatz_music/views/playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<SongModel> songs = [];

  CustomSearchDelegate({required this.songs});

  List<Audio> convetedList = [];
  @override
  String get searchFieldLabel => 'Search song';
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: scColor,
      scaffoldBackgroundColor: Colors.blueGrey,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: scColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.w400, color: subTextColor),
      ),
    );
  }

  @override
  buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
        //color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in songs) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.title);
      }
    }

    if (matchQuery.isEmpty) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: searchBgColor,
          begin: Alignment.bottomRight,
          end: Alignment.topCenter,
        )),
        child: Center(
          child: Text(
            'No songs',
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: searchBgColor,
        begin: Alignment.bottomRight,
        end: Alignment.topCenter,
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];

            int filterIndex = songs
                .indexWhere((element) => element.title == matchQuery[index]);

            return ListTile(
              leading: buildListTileLeading(songs, filterIndex, context),
              title: Text(
                result,
                maxLines: 2,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w300),
              ),
              onTap: () {
                // FocusScope.of(context).unfocus();

                Get.to(
                  PlayingScreen(
                    convertedList: convetedList,
                    songs: songs,
                    index: filterIndex,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
    // TODO: implement buildResults
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in songs) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.title);
      }
    }

    if (matchQuery.isEmpty) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: searchBgColor,
          begin: Alignment.bottomRight,
          end: Alignment.topCenter,
        )),
        child: Center(
          child: Text(
            'No songs',
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: searchBgColor,
        begin: Alignment.bottomRight,
        end: Alignment.topCenter,
      )),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];

            int filterIndex = songs
                .indexWhere((element) => element.title == matchQuery[index]);

            return ListTile(
              leading: buildListTileLeading(songs, filterIndex, context),
              title: Text(
                result,
                maxLines: 2,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w300),
              ),
              onTap: () {
                // print(index);
                FocusScope.of(context).unfocus();
                convertAudioFile(songs);

                Get.to(PlayingScreen(
                  convertedList: convetedList,
                  songs: songs,
                  index: filterIndex,
                ));
              },
            );
          },
        ),
      ),
    );
  }

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

  convertAudioFile(List<SongModel> songs) {
    for (var item in songs) {
      convetedList.add(
        Audio.file(
          item.uri.toString(),
          metas: Metas(
            id: item.id.toString(),
            title: item.title,
          ),
        ),
      );
    }
  }
}