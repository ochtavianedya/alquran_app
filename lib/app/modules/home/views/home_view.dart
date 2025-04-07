import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:alquran_app/app/data/models/surah_detail.dart' as detail;
import 'package:alquran_app/app/shared/widgets/custom_app_bar.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Al-Qur'an"),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Container(
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
                    onTap: () {},
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
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
                              child: Container(
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
                                  "Al-Fatihah",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Ayat Ke: 7 | Juz 1",
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
              ),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelColor: secondaryColorLight,
                tabs: [
                  Tab(text: "Surah"),
                  Tab(text: "Juz"),
                  Tab(text: "Bookmark"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListSurah(controller: controller),
                    ListJuz(controller: controller),
                    Center(child: Text("Bookmark")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedNavIndex.value,
          onTap: (index) => controller.selectedNavIndex.value = index,
          selectedItemColor: primaryColorLight,
          unselectedItemColor: secondaryColorLight,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Bookmark',
            ),
          ],
        ),
      ),
    );
  }
}

class ListJuz extends StatelessWidget {
  const ListJuz({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.getAllJuz(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColorLight),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }
        return ListView.separated(
          itemCount: snapshot.data!.length,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> dataMapPerJuz = snapshot.data![index];
            return ListTile(
              onTap: () {
                Get.toNamed('/juz-detail', arguments: dataMapPerJuz);
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

class ListSurah extends StatelessWidget {
  const ListSurah({super.key, required this.controller});

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
        return ListView.separated(
          itemCount: snapshot.data!.length,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            Surah surah = snapshot.data![index];
            return ListTile(
              onTap: () {
                Get.toNamed('/surah-detail', arguments: surah);
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
                  color: Get.isDarkMode ? primaryColorDark : primaryColorLight,
                ),
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
