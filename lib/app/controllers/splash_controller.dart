import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/routes/app_pages.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs;

  // Instancia de GetStorage (usa el mismo nombre que inicializaste en main.dart)
  final GetStorage _storage = GetStorage('GlobalStorage');

  @override
  void onInit() {
    super.onInit();
    startSplashSequence();
  }

  void startSplashSequence() {
    // Primero animamos la opacidad del logo a 1 después de 500ms
    Timer(const Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });

    // Mantenemos el logo visible hasta los 4 segundos
    Timer(const Duration(seconds: 4), () {
      opacity.value = 0.0;

      // Luego de 1 segundo más (mientras se desvanece el logo), verificamos la sesión
      Timer(const Duration(milliseconds: 1000), () {
        // Leemos la bandera 'loggedIn' de nuestro storage
        bool isLoggedIn = _storage.read('loggedIn') ?? false;

        if (isLoggedIn) {
          // Si el usuario ya está logueado, navegamos al Home
          Get.offNamed(Routes.HOME);
        } else {
          // De lo contrario, llevamos al Login
          Get.offNamed(Routes.LOGIN);
        }
      });
    });
  }
}
