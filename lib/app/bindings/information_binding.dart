
import 'package:get/get.dart';
import '../controllers/information_controller.dart';


class InformationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformationController>(() => InformationController());
  }
}