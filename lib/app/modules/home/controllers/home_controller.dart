import 'dart:convert';

import 'package:alquran_app/app/constants/theme.dart';
// import 'package:alquran_app/app/data/models/juz.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart';
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

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;

    List<Map<String, dynamic>> verseHolder = [];
    List<Map<String, dynamic>> allJuz = [];

    for (var i = 1; i <= 114; i++) {
      var res = await http.get(
        Uri.parse('https://api.quran.gading.dev/surah/$i'),
      );
      Map<String, dynamic> rawData = json.decode(res.body)['data'];
      SurahDetail data = SurahDetail.fromJson(rawData);
      for (var ayat in data.verses) {
        if (ayat.meta.juz == juz) {
          verseHolder.add({"surah": data, "ayat": ayat});
        } else {
          allJuz.add({
            "juz": juz,
            "start": verseHolder[0],
            "end": verseHolder[verseHolder.length - 1],
            "verses": verseHolder,
          });
          juz++;
          verseHolder = [];
          verseHolder.add({"surah": data, "ayat": ayat});
        }
      }
    }

    allJuz.add({
      "juz": juz,
      "start": verseHolder[0],
      "end": verseHolder[verseHolder.length - 1],
      "verses": verseHolder,
    });

    return allJuz;
  }
}
