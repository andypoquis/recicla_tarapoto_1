import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/bindings/home_binding.dart';
import 'package:recicla_tarapoto_1/app/bindings/login_binding.dart';
import 'package:recicla_tarapoto_1/app/bindings/register_binding.dart';
import 'package:recicla_tarapoto_1/app/bindings/splash_binding.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/login_page/login_page.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/register_page/register_page.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/splash_page/splash_page.dart';

import '../ui/pages/home_page/home_page.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(
        name: Routes.SPLASH,
        page: () => SplashPage(),
        binding: SplashBinding()),
    GetPage(
        name: Routes.REGISTER,
        page: () => RegisterPage(),
        binding: RegisterBinding()),
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
  ];
}
