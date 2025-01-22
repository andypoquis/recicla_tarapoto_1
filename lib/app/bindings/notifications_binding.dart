
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';


class NotificationsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}