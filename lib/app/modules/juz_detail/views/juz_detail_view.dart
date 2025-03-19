import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/data/models/juz.dart' as juz;
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/juz_detail_controller.dart';

class JuzDetailView extends GetView<JuzDetailController> {
  final juz.Juz detailJuz = Get.arguments["juz"];
  final List<Surah> allSurahInThisJuz = Get.arguments["surah"];
  JuzDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Juz ${detailJuz.juz}"),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<JuzDetailController>().toggleTheme();
            },
            icon: Obx(
              () =>
                  Get.find<JuzDetailController>().isDark.value
                      ? Icon(Icons.light_mode_outlined)
                      : Icon(Icons.dark_mode_outlined),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: detailJuz.verses.length,
        itemBuilder: (BuildContext context, int index) {
          if (detailJuz.verses.isEmpty) {
            return Center(child: Text("Tidak ada data"));
          }
          juz.Verse ayat = detailJuz.verses[index];
          if (index != 0) {
            if (ayat.number.inSurah == 1) {
              controller.index++;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
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
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    controller.isDark.isTrue
                                        ? 'assets/images/list_dark.png'
                                        : 'assets/images/list_light.png',
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${ayat.number.inSurah}",
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            ),
                            Text(
                              allSurahInThisJuz[controller.index]
                                  .name
                                  .transliteration
                                  .id,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 24.0,
                              color: purpleColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.bookmark_border_outlined,
                              size: 24.0,
                              color: purpleColor,
                            ),
                          ),
                        ],
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
          );
        },
      ),
    );
  }
}
