import 'package:get/get.dart';

class BrightnessController extends GetxController {
  var brightness1 = 0.0.obs;
  var brightness2 = 0.0.obs;

  void setBrightness1(double value) {
    brightness1.value = value;
  }

  void setBrightness2(double value) {
    brightness2.value = value;
  }
}
