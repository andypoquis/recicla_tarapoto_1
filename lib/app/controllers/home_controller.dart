// home_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  // Índice de la pestaña seleccionada
  RxInt selectedIndex = 0.obs;

  // Para saber si es recolector
  RxBool isCollector = false.obs;

  // Almacén local
  final GetStorage _box = GetStorage('GlobalStorage');

  // Aquí guardamos la info del usuario
  final Map<String, dynamic>? userMap = {};

  // Guarda el total de monedas que obtendremos desde Firestore
  RxDouble totalCoins = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Lee el valor que indica si es collector
    isCollector.value = _box.read('iscollector') ?? false;

    // Lee el userData (asegúrate que en tu login lo guardas con la misma clave)
    final Map<String, dynamic>? storedUserMap = _box.read('userData');
    if (storedUserMap != null) {
      userMap?.addAll(storedUserMap);
    }

    // Llamamos a un método que hace la consulta y suma las monedas
    fetchTotalCoins();
  }

  // Método para cambiar de pestaña
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  /// Consulta la colección 'wasteCollections' en Firestore y suma los totalCoins.
  /// Filtra por userReference == /users/$userId y isRecycled == true
  Future<void> fetchTotalCoins() async {
    try {
      // Asegúrate de extraer correctamente el ID del usuario
      // Asumiendo que en `userMap` está userMap['id'] o userMap['uid']
      final String? userId = userMap?['id'] ?? userMap?['uid'];
      if (userId == null) {
        // No tenemos userId, abortamos
        return;
      }

      // Construye la referencia del usuario en Firestore
      // Si en la BD guardas un DocumentReference, normalmente se ve así:
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Consulta a wasteCollections
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wasteCollections')
          .where('userReference', isEqualTo: userRef)
          .where('isRecycled', isEqualTo: true)
          .get();

      double sum = 0.0;
      for (var doc in querySnapshot.docs) {
        // Aquí obtienes el campo 'totalCoins'
        final data = doc.data();
        final double coins = _toDouble(data['totalCoins']);
        sum += coins;
      }

      // Asignamos al observable totalCoins
      totalCoins.value = sum;
    } catch (e) {
      print('Error al obtener totalCoins: $e');
      totalCoins.value = 0.0;
    }
  }

  // Conversión genérica a double
  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
