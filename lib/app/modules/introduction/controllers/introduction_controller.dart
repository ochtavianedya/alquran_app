import 'package:get/get.dart';

class IntroductionController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;
}
