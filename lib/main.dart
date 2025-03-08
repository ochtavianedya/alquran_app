import 'package:alquran_app/app/constants/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appLight,
      darkTheme: appDark,
      title: "Al-Qur'an App",
      initialRoute: '/introduction',
      getPages: AppPages.routes,
    ),
  );
}
