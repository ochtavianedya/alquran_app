import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class JuzDetailController extends GetxController {
  int index = 0;
  final player = AudioPlayer();
  final audioState = "stop".obs;
  RxInt currentAyatIndex = (-1).obs;

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
