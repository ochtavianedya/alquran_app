import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alquran_app/app/modules/home/views/tabs/bookmark_tab_view.dart';
import 'package:alquran_app/app/modules/home/views/tabs/home_tab_view.dart';
import 'package:alquran_app/app/modules/home/views/tabs/prayer_time_tab_view.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import 'package:alquran_app/app/shared/widgets/custom_app_bar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: controller.currentTitle,
          actions: [
            if (controller.selectedNavIndex.value == 1)
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
          ],
        ),
        body: IndexedStack(
          index: controller.selectedNavIndex.value,
          children: [
            // Home Tab View
            HomeTabView(controller: controller),

            // Prayer Time View (Waktu Shalat)
            PrayerTimeTabView(controller: controller),

            // Bookmark View
            BookmarkTabView(controller: controller),
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
