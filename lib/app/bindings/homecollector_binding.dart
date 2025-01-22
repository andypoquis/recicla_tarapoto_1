
import 'package:get/get.dart';
import '../controllers/homecollector_controller.dart';


class HomecollectorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomecollectorController>(() => HomecollectorController());
  }
}