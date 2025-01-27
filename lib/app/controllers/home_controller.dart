import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  // Índice de la pestaña seleccionada en el BottomNavigationBar
  RxInt selectedIndex = 0.obs;
  final GetStorage _box = GetStorage('GlobalStorage');

  // Observable que indicará si el usuario es "collector" o no
  RxBool isCollector = false.obs;

  // Referencia al almacenamiento de GetStorage

  @override
  void onInit() {
    super.onInit();
    // Lee el valor almacenado. Si no existe, por defecto será false.
    isCollector.value = _box.read('iscollector') ?? false;
    print('Es un recolecto? ${isCollector.value}');
  }

  // Método para cambiar de pestaña
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
