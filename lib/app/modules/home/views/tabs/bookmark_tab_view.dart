import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';

import '../../controllers/home_controller.dart';

class BookmarkTabView extends StatelessWidget {
  final HomeController controller;
  const BookmarkTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allJuzDataLoaded.isFalse) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryColorLight),
              const SizedBox(height: 10),
              Text("Memuat data all juz..."),
            ],
          ),
        );
      }

      // Show bookmarks using reactive list
      if (controller.bookmarkList.isEmpty) {
        return const Center(child: Text("Bookmarks tidak ada"));
      }

      return ListView.builder(
        itemCount: controller.bookmarkList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = controller.bookmarkList[index];
          return ListTile(
            onTap: () {
              switch (data["via"]) {
                case "juz":
                  Map<String, dynamic> dataMapPerJuz =
                      controller.allJuz[data["juz"] - 1];
                  Get.toNamed(
                    '/juz-detail',
                    arguments: {"juz": dataMapPerJuz, "bookmark": data},
                  );
                  break;
                default:
                  Get.toNamed(
                    '/surah-detail',
                    arguments: {
                      "name": data["surah"].toString().replaceAll("+", "'"),
                      "number": data["surah_number"],
                      "bookmark": data,
                    },
                  );
                  break;
              }
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
              data['surah'].toString().replaceAll("+", "'"),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              "Ayat ${data['ayat']} - via ${data['via']}",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: secondaryColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Get.defaultDialog(
                  title: "Hapus Bookmark",
                  titleStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  middleText: "Apakah anda yakin?",
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        controller.deleteBookmark(data['id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Batal"),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    });
  }
}
