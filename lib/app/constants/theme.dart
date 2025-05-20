import 'package:alquran_app/app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColorLight,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: primaryColorLight,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  iconTheme: IconThemeData(color: primaryColorLight),
  tabBarTheme: TabBarTheme(
    labelColor: primaryColorLight,
    indicatorColor: primaryColorLight,
  ),
  dialogTheme: DialogTheme(backgroundColor: Colors.white),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
);

ThemeData appDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColorDark,
  scaffoldBackgroundColor: primaryBgColorDark,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryBgColorDark,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    indicatorColor: primaryColorDark,
  ),
  dialogTheme: DialogTheme(backgroundColor: primaryBgColorDark),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xff121931),
  ),
);
