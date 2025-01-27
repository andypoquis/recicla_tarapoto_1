
import 'package:get/get.dart';
import '../controllers/user_controller.dart';


class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}