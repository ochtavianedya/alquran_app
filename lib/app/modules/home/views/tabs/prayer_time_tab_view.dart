import 'package:alquran_app/app/constants/color.dart';
import 'package:alquran_app/app/modules/home/controllers/home_controller.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PrayerTimeTabView extends StatelessWidget {
  final HomeController controller;
  const PrayerTimeTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Prayer times data
    final List<Map<String, String>> prayerTimes = [
      {'name': 'Imsak', 'time': '04:25'},
      {'name': 'Subuh', 'time': '04:35'},
      {'name': 'Fajr', 'time': '05:52'},
      {'name': 'Dhuha', 'time': '07:00'},
      {'name': 'Dzuhur', 'time': '11:47'},
      {'name': 'Ashar', 'time': '15:03'},
      {'name': 'Maghrib', 'time': '17:42'},
      {'name': 'Isya', 'time': '18:54'},
    ];

    DateTime now = DateTime.now();
    String formatedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(now);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Section
          Text(
            'Lokasi Anda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: secondaryColorDark,
            ),
          ),
          const SizedBox(height: 4),
          IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color:
                    ThemeController.to.isDarkMode
                        ? Color(0xff121931)
                        : Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 24),
                    const SizedBox(width: 10),
                    Text("Jombang", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),

          // Prayer Time Card
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: Get.height * 0.25,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColorLight, primaryColorDark],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/images/masjid_al_nabawi.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatedDate, style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        "06 Dzulhijjah 1446 H",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "06:00:00",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Maghrib kurang dari",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "05:23",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Date Navigation
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 60,
            width: Get.width,
            decoration: BoxDecoration(
              color:
                  ThemeController.to.isDarkMode
                      ? Color(0xff121931)
                      : Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios, size: 24, color: Colors.grey),
                  Column(
                    children: [
                      Text(
                        formatedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              ThemeController.to.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "06 Dzulhijjah 1446 H",
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryColorLight,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 24, color: Colors.grey),
                ],
              ),
            ),
          ),

          // Prayer Times List
          Expanded(
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                color:
                    ThemeController.to.isDarkMode
                        ? Color(0xff121931)
                        : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: prayerTimes.length,
                      itemBuilder: (context, index) {
                        final prayer = prayerTimes[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: primaryColorLight.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.access_time,
                                      color: primaryColorLight,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    prayer['name']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ThemeController.to.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                prayer['time']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColorLight,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
