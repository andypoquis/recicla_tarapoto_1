import 'package:get/get.dart';

import '../controllers/allredeemedincentives_controller.dart';

class AllredeemedincentivesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllRedeemedIncentivesController>(
        () => AllRedeemedIncentivesController());
  }
}
