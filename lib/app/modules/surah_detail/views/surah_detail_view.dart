import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart' as detail;
import 'package:alquran_app/app/modules/home/controllers/home_controller.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import 'package:alquran_app/app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/surah_detail_controller.dart';

class SurahDetailView extends GetView<SurahDetailController> {
  final homeC = Get.find<HomeController>();
  SurahDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? bookmark;
    return Scaffold(
      appBar: CustomAppBar(title: "Surah ${Get.arguments['name']}"),
      body: FutureBuilder<detail.SurahDetail>(
        future: controller.getSurahDetail(Get.arguments['number'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColorLight),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data."));
          }

          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];

            // Ensure index_ayat is treated as an integer
            int indexAyat =
                bookmark!["index_ayat"] is int
                    ? bookmark!["index_ayat"]
                    : int.parse(bookmark!["index_ayat"].toString());

            controller.scrollC.scrollToIndex(
              indexAyat + 2,
              preferPosition: AutoScrollPosition.begin,
            );
          }

          detail.SurahDetail surah = snapshot.data!;

          List<Widget> listAyat = List.generate(snapshot.data!.verses.length, (
            index,
          ) {
            detail.Verse? ayat = snapshot.data!.verses[index];
            return AutoScrollTag(
              key: ValueKey(index + 2),
              index: index + 2,
              controller: controller.scrollC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColorLight.withValues(alpha: 0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    ThemeController.to.isDarkMode
                                        ? 'assets/images/list_dark.png'
                                        : 'assets/images/list_light.png',
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          GetBuilder<SurahDetailController>(
                            builder:
                                (c) => Row(
                                  children: [
                                    // If this verse is not playing
                                    (c.currentAyatIndex.value != index)
                                        ? IconButton(
                                          onPressed: () {
                                            c.playAyat(
                                              ayat.audio.primary,
                                              index,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.play_arrow,
                                            size: 24.0,
                                            color: purpleColor,
                                          ),
                                        )
                                        : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (c.audioState.value == "play")
                                                ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAyat();
                                                  },
                                                  icon: const Icon(
                                                    Icons.pause,
                                                    size: 24.0,
                                                    color: purpleColor,
                                                  ),
                                                )
                                                : IconButton(
                                                  onPressed: () {
                                                    c.resumeAyat();
                                                  },
                                                  icon: const Icon(
                                                    Icons.play_arrow,
                                                    size: 24.0,
                                                    color: purpleColor,
                                                  ),
                                                ),
                                            IconButton(
                                              onPressed: () {
                                                c.stopAyat();
                                              },
                                              icon: const Icon(
                                                Icons.stop,
                                                size: 24.0,
                                                color: purpleColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                    IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "Bookmark",
                                          titleStyle: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          middleText: "Pilih jenis bookmark",
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                c.addBookmark(
                                                  true,
                                                  snapshot.data!,
                                                  ayat,
                                                  index,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    primaryColorLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                "Last Read",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                c.addBookmark(
                                                  false,
                                                  snapshot.data!,
                                                  ayat,
                                                  index,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    primaryColorLight,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                "Bookmark",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.bookmark_add_outlined,
                                        size: 24.0,
                                        color: purpleColor,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      ayat.text.arab,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.amiri(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ayat.translation.id,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          });

          // snapshot has data
          return ListView(
            controller: controller.scrollC,
            padding: const EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: GestureDetector(
                  onTap:
                      () => Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Tafsir ${surah.name.transliteration.id}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  surah.tafsir.id,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  child: Container(
                    width: Get.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColorLight, primaryColorDark],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            surah.name.transliteration.id,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "( ${surah.name.translation.id} )",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${surah.revelation.id} | ${surah.numberOfVerses} Ayat",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: const SizedBox(height: 20),
              ),
              ...listAyat,
            ],
          );
        },
      ),
    );
  }
}
