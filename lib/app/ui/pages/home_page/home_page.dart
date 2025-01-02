// lib/modules/home/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/home_controller.dart';

import '../home_screen/home_screen.dart';
import '../incentives_page/incentives_page.dart';
import '../information_page/information_page.dart';
import '../user_page/user_page.dart';

// Importa tus otras vistas

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  // Lista de páginas que se mostrarán en el body según selectedIndex
  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    InformationScreen(),
    IncentivesScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Logo
            Image.asset(
              'lib/assets/logo_completo.png',
              height: 49,
            ),
          ],
        ),
        actions: [
          // Ícono de notificaciones
          Stack(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.notifications),
                iconSize: 36.0,
                onPressed: () {
                  // Acción al presionar notificaciones
                },
              ),
              Positioned(
                right: 3,
                top: 1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 89, 217, 153),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 21,
                    minHeight: 21,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          // Ícono de balance
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.monetization_on),
                color: Colors.white,
                iconSize: 36.0,
                onPressed: () {
                  // Acción al presionar el balance
                },
              ),
              Positioned(
                right: 3,
                top: 1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 89, 217, 153),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 21,
                    minHeight: 21,
                  ),
                  child: const Text(
                    '\$50',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF59D999), Color(0xFF31ADA0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // BODY: según la pestaña seleccionada
      body: Obx(
        () => Center(
          child: _pages.elementAt(controller.selectedIndex.value),
        ),
      ),
      // BottomNavigationBar
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onItemTapped,
          backgroundColor: const Color(0xFF11998E),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green.shade300,
          unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
