import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeController extends GetxController {
  final audioQuery = OnAudioQuery();
  var hasPermission = false.obs;
  List<SongModel> fechsongsall = [];

  @override
  void onInit() {
    checkAndRequestPermissions();

    super.onInit();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    hasPermission.value = (await audioQuery.checkAndRequest(
      retryRequest: retry,
    ));

    fechsongsall = await audioQuery.querySongs();
  }
}