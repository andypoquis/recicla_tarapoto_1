// lib/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Índice de la pestaña seleccionada en el BottomNavigationBar
  RxInt selectedIndex = 0.obs;

  // Método para cambiar de pestaña
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
