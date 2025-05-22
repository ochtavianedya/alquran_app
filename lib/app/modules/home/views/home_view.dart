import 'package:alquran_app/app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_app/app/modules/home/views/tabs/home_tab_view.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import 'package:alquran_app/app/shared/widgets/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(title: controller.currentTitle),
        body: IndexedStack(
          index: controller.selectedNavIndex.value,
          children: [
            // Home Tab View
            HomeTabView(controller: controller),

            // Prayer Time View
            Center(
              child: Text('Prayer Time View', style: TextStyle(fontSize: 24)),
            ),

            // Bookmark View
            GetBuilder<HomeController>(
              builder: (controller) {
                return FutureBuilder(
                  future: controller.getBookmark(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColorLight,
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("Bookmarks tidak ada"));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data![index];
                        return ListTile(
                          onTap: () {},
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
                                      Get.back();
                                      controller.deleteBookmark(data['id']);
                                    },
                                    child: Text(
                                      "Hapus",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "Batal",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColorLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedNavIndex.value,
          onTap: (index) => controller.selectedNavIndex.value = index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            // Home
            BottomNavigationBarItem(
              icon: Image.asset(
                ThemeController.to.isDarkMode
                    ? 'assets/icons/alquran_dark.png'
                    : 'assets/icons/alquran_light.png',
                width: 32,
                height: 32,
              ),
              activeIcon: Image.asset(
                ThemeController.to.isDarkMode
                    ? 'assets/icons/alquran_active_dark.png'
                    : 'assets/icons/alquran_active_light.png',
                width: 32,
                height: 32,
              ),
              label: 'Home',
            ),
            // Prayer Time
            BottomNavigationBarItem(
              icon: Image.asset(
                ThemeController.to.isDarkMode
                    ? 'assets/icons/pray_dark.png'
                    : 'assets/icons/pray_light.png',
                width: 32,
                height: 32,
              ),
              activeIcon: Image.asset(
                ThemeController.to.isDarkMode
                    ? 'assets/icons/pray_active_dark.png'
                    : 'assets/icons/pray_active_light.png',
                width: 32,
                height: 32,
              ),
              label: 'Prayer Time',
            ),
            // Bookmark
            BottomNavigationBarItem(
              icon: Image.asset(
                ThemeController.to.isDarkMode
                    ? 'assets/icons/bookmark_dark.png'
                    : 'assets/icons/bookmark_light.png',
                width: 32,
                height: 32,
              ),
              activeIcon: Image.asset(
                ThemeController.to.isDarkMode
                    ? 'assets/icons/bookmark_active_dark.png'
                    : 'assets/icons/bookmark_active_light.png',
                width: 32,
                height: 32,
              ),
              label: 'Bookmark',
            ),
          ],
        ),
      ),
    );
  }
}
