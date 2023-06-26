import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beatz_music/views/playing_screen.dart';
import 'package:beatz_music/views/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import '../consts.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/home_controller.dart';
import 'customsearch.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<Audio> convertedList = [];
  OnAudioRoom audioRoom = OnAudioRoom();
  final audioQuery = OnAudioQuery();
  List<SongModel>? songs;

  //List pages = [FavoriteScreen(), PlaylistScreen()];
  List name = ['Playlists', 'Favourites'];
  List imageUrl = [
    'asset/images/playlist_cover.png',
    'asset/images/favorite_cover.png'
  ];

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    var favoriteController = Get.put(FavouriteController());
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: scColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: scColor,
          centerTitle: true,
          toolbarHeight: 70,
          // title: Text(
          //   "B e a t z z",
          //   style: TextStyle(color: titleColor, fontSize: 30),
          // ),
          title: Container(
            height: 80,
            width: 150,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/images/title.png"),
                    fit: BoxFit.cover)),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                          songs: homeController.fechsongsall));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Center(child: Obx(() {
          if (!homeController.hasPermission.value) {
            return const Text("no songs");
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<SongModel>>(
                        future: homeController.audioQuery.querySongs(
                            ignoreCase: true,
                            orderType: OrderType.ASC_OR_SMALLER,
                            sortType: null,
                            uriType: UriType.EXTERNAL),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          if (snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "No songs found",
                                style: TextStyle(color: textColor),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  height: 190,
                                  child: GridView.builder(

                                      //shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.99),
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (index == 0) {
                                              Get.to(() => PlaylistScreen());
                                            } else {
                                              Get.to(() => FavoriteScreen());
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(9),
                                            child: GridTile(
                                                footer: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20)),
                                                    color: Colors.black26,
                                                  ),
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      name[index],
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: textColor),
                                                    ),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  imageUrl[
                                                                      index]),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: scColor,
                                                          gradient:
                                                              const LinearGradient(
                                                                  colors: [
                                                                Colors.black12,
                                                                Colors.black12
                                                              ])),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      //shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        songs = snapshot.data;
                                        return ListTile(
                                          leading: QueryArtworkWidget(
                                            artworkWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            artworkHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.12,
                                            id: songs![index].id,
                                            type: ArtworkType.AUDIO,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.14,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.12,
                                            ),
                                          ),
                                          title: Text(
                                            overflow: TextOverflow.ellipsis,
                                            songs![index].title,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          subtitle: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            "${songs![index].artist}",
                                            style: TextStyle(
                                                color: subTextColor,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13),
                                          ),
                                          trailing: PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: textColor,
                                              size: 30,
                                            ),
                                            color: const Color.fromARGB(
                                                195, 44, 105, 134),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<Text>>[
                                              PopupMenuItem(
                                                  onTap: () async {
                                                    bool isAdded =
                                                        await audioRoom.checkIn(
                                                            RoomType.FAVORITES,
                                                            songs![index].id);
                                                    audioRoom.addTo(
                                                      RoomType.FAVORITES,
                                                      songs![index]
                                                          .getMap
                                                          .toFavoritesEntity(),
                                                      ignoreDuplicate: false,
                                                    );
                                                    favoriteController
                                                        .addToFavourite(songs!,
                                                            index, isAdded);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "Add to favourites",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                      Icon(Icons.favorite,
                                                          color: titleColor)
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  child: GestureDetector(
                                                onTap: () {
                                                  Get.back();

                                                  Get.to(() => PlaylistScreen(
                                                        songIndex: index,
                                                        songs: songs,
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Add to playlist",
                                                      style: TextStyle(
                                                          color: textColor),
                                                    ),
                                                    Icon(Icons.playlist_add,
                                                        color: titleColor)
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                          onTap: () {
                                            convertAudioFile(homeController);

                                            Get.to(() => PlayingScreen(
                                                  convertedList: convertedList,
                                                  songs: songs,
                                                  index: index,
                                                ));
                                          },
                                        );
                                      }),
                                ),
                              ],
                            );
                          }
                        }),
                  ),
                ],
              ),
            );
          }
        })),
      ),
    );
  }

  convertAudioFile(homeController) {
    for (var item in homeController.fechsongsall) {
      convertedList.add(
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