import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/userinventory_controller.dart';

class UserinventoryPage extends GetView<UserinventoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('UserinventoryController'),
      ),
    );
  }
}
