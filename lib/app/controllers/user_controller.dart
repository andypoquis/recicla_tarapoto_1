import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/data/models/usermodel.dart';

import '../data/provider/authprovider.dart';

class UserController extends GetxController {
  final GetStorage _box = GetStorage('GlobalStorage');
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  // Guardamos al recolector en caso de que el usuario actual NO sea recolector
  Rx<UserModel?> collectorModel = Rx<UserModel?>(null);

  // Inyectamos AuthProvider para poder llamar signOut
  final AuthProvider _authProvider = AuthProvider();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final Map<String, dynamic>? userMap = _box.read('userData');
    if (userMap != null) {
      userModel.value = UserModel.fromFirestore(userMap);
      print("User loaded from storage: ${userModel.value!.uid}");
    } else {
      userModel.value = null;
    }

    // Si el usuario actual NO es recolector, buscamos en Firestore a quien sí lo sea
    if (userModel.value != null && userModel.value!.iscollector == false) {
      _loadCollectorFromFirestore();
    }
  }

  /// Obtiene de Firestore al primer usuario con iscollector == true
  Future<void> _loadCollectorFromFirestore() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('iscollector', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        collectorModel.value = UserModel.fromFirestore(data);
      } else {
        collectorModel.value = null;
      }
    } catch (e) {
      // Manejo de errores en caso de que falle la consulta
      collectorModel.value = null;
      rethrow;
    }
  }

  /// Cierra sesión, borra datos en Storage y redirige a /login
  Future<void> logout() async {
    await _authProvider.signOut();
    await _box.erase(); // Borra todos los datos del local storage
    Get.offAllNamed('/login');
  }
}
