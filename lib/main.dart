import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/bindings/splash_binding.dart';
import 'package:recicla_tarapoto_1/app/routes/app_pages.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/splash_page/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase

  // Inicializa GetStorage
  await GetStorage.init('GlobalStorage'); // Inicializa GetStorage
  GetStorage box = GetStorage('GlobalStorage');
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.SPLASH,
    theme: ThemeData(),
    defaultTransition: Transition.fade,
    initialBinding: SplashBinding(),
    home: SplashPage(),
    getPages: AppPages.pages,
  ));
}
