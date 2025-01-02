import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/homescreen_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/incentives_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/information_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<InformationController>(() => InformationController());
    Get.lazyPut<IncentivesController>(() => IncentivesController());
    Get.lazyPut<UserController>(() => UserController());
  }
}
