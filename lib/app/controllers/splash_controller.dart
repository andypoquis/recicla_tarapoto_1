import 'dart:async';

import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/routes/app_pages.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    startSplashSequence();
  }

  void startSplashSequence() {
    Timer(Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });

    Timer(Duration(seconds: 4), () {
      opacity.value = 0.0;

      Timer(Duration(milliseconds: 1000), () {
        Get.offNamed(Routes.LOGIN);
      });
    });
  }
}
