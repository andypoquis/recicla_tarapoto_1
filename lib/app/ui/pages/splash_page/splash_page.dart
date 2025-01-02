// lib/modules/home/views/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(89, 217, 153, 1),
              Color.fromRGBO(49, 173, 161, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Obx(
            () => AnimatedOpacity(
              opacity: controller.opacity.value,
              duration: const Duration(seconds: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/logo_completo.png',
                    width: 247,
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
