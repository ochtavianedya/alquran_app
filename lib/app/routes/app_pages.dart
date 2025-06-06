import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/juz_detail/bindings/juz_detail_binding.dart';
import '../modules/juz_detail/views/juz_detail_view.dart';
import '../modules/surah_detail/bindings/surah_detail_binding.dart';
import '../modules/surah_detail/views/surah_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.introduction,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.surahDetail,
      page: () => SurahDetailView(),
      binding: SurahDetailBinding(),
    ),
    GetPage(
      name: _Paths.juzDetail,
      page: () => JuzDetailView(),
      binding: JuzDetailBinding(),
    ),
  ];
}
