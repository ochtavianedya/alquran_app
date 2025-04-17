import 'dart:convert';

import 'package:alquran_app/app/data/models/surah_detail.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class SurahDetailController extends GetxController {
  final player = AudioPlayer();
  final audioState = "stop".obs;
  RxInt currentAyatIndex = (-1).obs;

  Future<SurahDetail> getSurahDetail(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)['data'];

    return SurahDetail.fromJson(data);
  }

  void playAyat(String audioUrl, int index) async {
    try {
      await player.stop();
      currentAyatIndex.value = index;
      await player.setUrl(audioUrl);
      audioState.value = "play";
      update();

      await player.play();

      // When audio finishes playing
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          audioState.value = "stop";
          currentAyatIndex.value = -1;
          update();
        }
      });
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat play audio",
      );
    }
  }

  void pauseAyat() async {
    try {
      await player.pause();
      audioState.value = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat pause audio",
      );
    }
  }

  void resumeAyat() async {
    try {
      audioState.value = "play";
      update();
      await player.play();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat resume audio",
      );
    }
  }

  void stopAyat() async {
    try {
      await player.stop();
      audioState.value = "stop";
      currentAyatIndex.value = -1;
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak dapat stop audio",
      );
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
