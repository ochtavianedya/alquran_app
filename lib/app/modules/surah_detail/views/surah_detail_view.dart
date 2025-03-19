import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart' as surah_detail;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/surah_detail_controller.dart';

class SurahDetailView extends GetView<SurahDetailController> {
  final Surah surah = Get.arguments;

  SurahDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surah ${surah.name.transliteration.id}"),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<SurahDetailController>().toggleTheme();
            },
            icon: Obx(
              () =>
                  Get.find<SurahDetailController>().isDark.value
                      ? Icon(Icons.light_mode_outlined)
                      : Icon(Icons.dark_mode_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
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
          const SizedBox(height: 20),
          FutureBuilder<surah_detail.SurahDetail>(
            future: controller.getSurahDetail(surah.number.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("Tidak ada data"));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.verses.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.verses.isEmpty) {
                    return SizedBox();
                  }
                  surah_detail.Verse? ayat = snapshot.data!.verses[index];
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
                                () => Container(
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
                                      "${index + 1}",
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                                  ),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
