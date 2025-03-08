import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/constants/theme.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Al-Qur\'an App'),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<HomeController>().toggleTheme();
            },
            icon: Obx(
              () =>
                  Get.find<HomeController>().isDark.value
                      ? Icon(Icons.light_mode_outlined)
                      : Icon(Icons.dark_mode_outlined),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),

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
                    AllSurah(controller: controller),
                    ListView.builder(
                      itemCount: 30,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {},
                          leading: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/list_light.png',
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
                          title: Text(
                            "Juz ${index + 1}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Al-Fatihah Ayat 1-7",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: secondaryColorLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                    Center(child: Text("Bookmark")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllSurah extends StatelessWidget {
  const AllSurah({super.key, required this.controller});

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
                        controller.isDark.isTrue
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
