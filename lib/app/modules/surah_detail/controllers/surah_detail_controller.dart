import 'dart:convert';

import 'package:alquran_app/app/data/models/surah_detail.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SurahDetailController extends GetxController {
  Future<SurahDetail> getSurahDetail(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)['data'];

    return SurahDetail.fromJson(data);
  }
}
