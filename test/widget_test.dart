import 'dart:convert';

import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart';
import 'package:http/http.dart' as http;

void main() async {
  Future<SurahDetail> getSurahDetail(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)['data'];

    SurahDetail test = SurahDetail.fromJson(data);
    print(test.verses);
    return SurahDetail.fromJson(data);
  }

  await getSurahDetail(1.toString());

  // Uri url = Uri.parse('https://api.quran.gading.dev/surah');
  // var res = await http.get(url);

  // List data = (json.decode(res.body) as Map<String, dynamic>)['data'];
}
