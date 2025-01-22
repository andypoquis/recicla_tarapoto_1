
import 'package:get/get.dart';
import '../controllers/profilecollector_controller.dart';


class ProfilecollectorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilecollectorController>(() => ProfilecollectorController());
  }
}