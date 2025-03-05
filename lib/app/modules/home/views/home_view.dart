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
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: FutureBuilder<List<Surah>>(
        future: controller.getAllSurah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Surah surah = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Get.toNamed(Routes.SURAH_DETAIL, arguments: surah);
                },
                leading: CircleAvatar(
                  backgroundColor: Color(0xff672CBC),
                  child: Text(
                    "${surah.number}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  "Surah ${surah.name.transliteration.id}",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                subtitle: Text(
                  "${surah.revelation.id} | ${surah.numberOfVerses} Ayat",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xff8789A3),
                  ),
                ),
                trailing: Text(
                  "${surah.name.short}",
                  style: GoogleFonts.amiri(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff672CBC),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
