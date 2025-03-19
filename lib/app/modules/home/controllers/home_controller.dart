import 'dart:convert';

import 'package:alquran_app/app/constants/theme.dart';
import 'package:alquran_app/app/data/models/juz.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  RxBool isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? appDark : appLight);
  }

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');
    var res = await http.get(url);

    List? data = (json.decode(res.body) as Map<String, dynamic>)['data'];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      Uri url = Uri.parse('https://api.quran.gading.dev/juz/$i');
      var res = await http.get(url);

      Map<String, dynamic> data =
          (json.decode(res.body) as Map<String, dynamic>)['data'];

      Juz juz = Juz.fromJson(data);
      allJuz.add(juz);
    }
    return allJuz;
  }
}
