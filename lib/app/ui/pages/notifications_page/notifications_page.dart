import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/notifications_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('NotificationsController'),
      ),
    );
  }
}
