import 'package:alquran_app/app/constants/theme.dart';
import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  Get.put(ThemeController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appLight,
          darkTheme: appDark,
          themeMode: controller.themeMode,
          title: "Al-Qur'an App",
          initialRoute: '/introduction',
          getPages: AppPages.routes,
        );
      },
    );
  }
}
