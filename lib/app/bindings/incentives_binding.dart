
import 'package:get/get.dart';
import '../controllers/incentives_controller.dart';


class IncentivesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncentivesController>(() => IncentivesController());
  }
}