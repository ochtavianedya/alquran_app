import 'dart:convert';

import 'package:alquran_app/app/constants/theme.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SurahDetailController extends GetxController {
  RxBool isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? appDark : appLight);
  }

  Future<SurahDetail> getSurahDetail(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)['data'];

    return SurahDetail.fromJson(data);
  }
}
