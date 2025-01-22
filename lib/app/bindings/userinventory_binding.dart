
import 'package:get/get.dart';
import '../controllers/userinventory_controller.dart';


class UserinventoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserinventoryController>(() => UserinventoryController());
  }
}