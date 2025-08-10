// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/routes/app_pages.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/splash_page/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init('GlobalStorage');

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
      theme: ThemeData(),
      defaultTransition: Transition.fade,
      home: SplashPage(),
      getPages: AppPages.pages,

      // 👇 Limita el escalado de texto globalmente (solo usamos textScaler)
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final double clamped =
            mq.textScaleFactor.clamp(1.0, 1.1); // leemos, pero no lo seteamos
        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(clamped),
            // ⚠️ NO pongas textScaleFactor aquí, causa la aserción
          ),
          child: child!,
        );
      },
    ),
  );
}
