
import 'package:get/get.dart';
import '../controllers/register_controller.dart';


class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}