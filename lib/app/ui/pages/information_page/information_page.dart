// lib/modules/home/views/information_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/information_controller.dart';

class InformationScreen extends GetView<InformationController> {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Información',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Aquí tu contenido
            ],
          ),
        ),
      ),
    );
  }
}
