import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/homecollector_controller.dart';

class HomecollectorPage extends GetView<HomecollectorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('HomecollectorController'),
      ),
    );
  }
}
