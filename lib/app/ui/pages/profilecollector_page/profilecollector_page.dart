import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profilecollector_controller.dart';

class ProfilecollectorPage extends GetView<ProfilecollectorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('ProfilecollectorController'),
      ),
    );
  }
}
