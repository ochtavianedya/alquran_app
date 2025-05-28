import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart' as detail;
import 'package:alquran_app/app/shared/controller/theme_controller.dart';

import '../../controllers/home_controller.dart';

class HomeTabView extends StatelessWidget {
  final HomeController controller;
  const HomeTabView({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              "Assalamu'alaikum",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: secondaryColorDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Ochtavian Edya",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // Search bar
            Obx(
              () => TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Surah...',
                  hintStyle: GoogleFonts.poppins(
                    color: secondaryColorLight,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: secondaryColorLight,
                  ),
                  suffixIcon:
                      controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: secondaryColorLight,
                            ),
                            onPressed: controller.clearSearch,
                          )
                          : null,
                  filled: true,
                  fillColor:
                      ThemeController.to.isDarkMode
                          ? Color(0xff121931)
                          : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),

            // Last read card
            GetBuilder<HomeController>(
              builder:
                  (c) => FutureBuilder<Map<String, dynamic>?>(
                    future: c.getLastRead(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          height: 150,
                          width: Get.width,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColorLight, primaryColorDark],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -50,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: SizedBox(
                                    width: 170,
                                    height: 170,
                                    child: Image.asset(
                                      'assets/images/quran.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.menu_book_rounded,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "Terakhir dibaca",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "Loading...",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      Map<String, dynamic>? lastRead = snapshot.data;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [primaryColorDark, primaryColorLight],
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: InkWell(
                            onLongPress: () {
                              if (lastRead != null) {
                                Get.defaultDialog(
                                  title: "Hapus Last Read",
                                  titleStyle: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  middleText: "Apakah anda yakin?",
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        c.deleteBookmark(lastRead['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text("Batal"),
                                    ),
                                  ],
                                );
                              }
                            },
                            onTap: () {
                              if (lastRead != null) {
                                switch (lastRead["via"]) {
                                  case "juz":
                                    Map<String, dynamic> dataMapPerJuz =
                                        controller.allJuz[lastRead["juz"] - 1];
                                    Get.toNamed(
                                      '/juz-detail',
                                      arguments: {
                                        "juz": dataMapPerJuz,
                                        "bookmark": lastRead,
                                      },
                                    );
                                    break;
                                  default:
                                    Get.toNamed(
                                      '/surah-detail',
                                      arguments: {
                                        "name": lastRead["surah"]
                                            .toString()
                                            .replaceAll("+", "'"),
                                        "number": lastRead["surah_number"],
                                        "bookmark": lastRead,
                                      },
                                    );
                                    break;
                                }
                              }
                            },
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              height: 150,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColorLight, primaryColorDark],
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: -50,
                                    right: 0,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: SizedBox(
                                        width: 170,
                                        height: 170,
                                        child: Image.asset(
                                          'assets/images/quran.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.menu_book_rounded,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Terakhir dibaca",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        Text(
                                          lastRead == null
                                              ? ""
                                              : lastRead['surah']
                                                  .toString()
                                                  .replaceAll("+", "'"),
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          lastRead == null
                                              ? "Belum ada data"
                                              : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),

            // Tabs bar
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelColor: secondaryColorLight,
              tabs: const [Tab(text: "Surah"), Tab(text: "Juz")],
            ),

            // Tabs content
            Expanded(
              child: TabBarView(
                children: [
                  SurahList(controller: controller),
                  JuzList(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JuzList extends StatelessWidget {
  const JuzList({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.getAllJuz(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          controller.allJuzDataLoaded.value = false;
          return const Center(
            child: CircularProgressIndicator(color: primaryColorLight),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        controller.allJuzDataLoaded.value = true;

        return ListView.separated(
          itemCount: snapshot.data!.length,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> dataMapPerJuz = snapshot.data![index];
            return ListTile(
              onTap: () {
                Get.toNamed('/juz-detail', arguments: {"juz": dataMapPerJuz});
              },
              leading: Obx(
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
              title: Text(
                "Juz ${index + 1}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Mulai dari ${(dataMapPerJuz['start']['surah'] as detail.SurahDetail).name.transliteration.id} ayat ${(dataMapPerJuz['start']['ayat'] as detail.Verse).number.inSurah}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: secondaryColorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Sampai ${(dataMapPerJuz['end']['surah'] as detail.SurahDetail).name.transliteration.id} ayat ${(dataMapPerJuz['end']['ayat'] as detail.Verse).number.inSurah}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: secondaryColorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        );
      },
    );
  }
}

class SurahList extends StatelessWidget {
  const SurahList({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: controller.getAllSurah(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColorLight),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        return Obx(() {
          List<Surah> dataToShow =
              controller.searchQuery.value.isEmpty
                  ? snapshot.data!
                  : controller.filteredSurah;

          if (dataToShow.isEmpty && controller.searchQuery.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: secondaryColorLight),
                  const SizedBox(height: 16),
                  Text(
                    "Surah tidak ditemukan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: secondaryColorLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: dataToShow.length,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Surah surah = dataToShow[index];
              return ListTile(
                onTap: () {
                  Get.toNamed(
                    '/surah-detail',
                    arguments: {
                      "name": surah.name.transliteration.id,
                      "number": surah.number,
                    },
                  );
                },
                leading: Obx(
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
                        "${surah.number}",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  surah.name.transliteration.id,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "${surah.revelation.id} | ${surah.numberOfVerses} Ayat",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: secondaryColorLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  surah.name.short,
                  style: GoogleFonts.amiri(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color:
                        ThemeController.to.isDarkMode
                            ? primaryColorDark
                            : primaryColorLight,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        });
      },
    );
  }
}
