import 'package:alquran_app/app/constants/theme.dart';
import 'package:get/get.dart';

class JuzDetailController extends GetxController {
  int index = 0;
  RxBool isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? appDark : appLight);
  }
}
