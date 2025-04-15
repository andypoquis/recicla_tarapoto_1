import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/homecollector_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/homescreen_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/incentives_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/information_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/userinventory_controller.dart';

import '../controllers/allredeemedincentives_controller.dart';
import '../controllers/home_controller.dart';
import '../ui/pages/notifications_page/notifications_page.dart';
import '../ui/pages/profilecollector_page/profilecollector_page.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<InformationController>(() => InformationController());
    Get.lazyPut<IncentivesController>(() => IncentivesController());
    Get.lazyPut<UserController>(() => UserController());

    Get.lazyPut<HomecollectorController>(() => HomecollectorController());
    Get.lazyPut<UserinventoryController>(() => UserinventoryController());
    Get.lazyPut<NotificationsPage>(() => NotificationsPage());
    Get.lazyPut<ProfilecollectorPage>(() => ProfilecollectorPage());
    Get.lazyPut<AllRedeemedIncentivesController>(
        () => AllRedeemedIncentivesController());
  }
}
