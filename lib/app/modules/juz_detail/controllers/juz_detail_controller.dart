import 'package:alquran_app/app/data/db/bookmark.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

// Import home controller to refresh bookmarks
import '../../home/controllers/home_controller.dart';

class JuzDetailController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();

  int index = 0;
  final player = AudioPlayer();
  final audioState = "stop".obs;
  RxInt currentAyatIndex = (-1).obs;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
    bool lastRead,
    SurahDetail surah,
    Verse ayat,
    int indexAyat,
  ) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query(
        "bookmark",
        columns: [
          "surah",
          "surah_number",
          "ayat",
          "juz",
          "via",
          "index_ayat",
          "last_read",
        ],
        where:
            "surah = '${surah.name.transliteration.id.replaceAll("'", "+")}' and surah_number = ${surah.number} and ayat = ${ayat.number.inSurah} and juz = ${ayat.meta.juz} and via = 'juz' and index_ayat = $indexAyat and last_read = 0",
      );
      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert("bookmark", {
        "surah": surah.name.transliteration.id.replaceAll("'", "+"),
        "surah_number": surah.number,
        "ayat": ayat.number.inSurah,
        "juz": ayat.meta.juz,
        "via": "juz",
        "index_ayat": indexAyat,
        "last_read": lastRead == true ? 1 : 0,
      });

      // Refresh bookmarks in HomeController after adding bookmark
      try {
        final homeController = Get.find<HomeController>();
        await homeController.loadBookmarks();
      } catch (e) {
        // print('HomeController not found: $e');
      }

      Get.back();
      Get.snackbar(
        "Sukses",
        "Bookmark telah ditambahkan",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 16,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      Get.back();
      Get.snackbar(
        "Terjadi kesalahan",
        "Bookmark sudah ada",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 16,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
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
