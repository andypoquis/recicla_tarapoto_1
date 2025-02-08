// lib/modules/home/controllers/user_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/data/models/usermodel.dart';

import '../data/provider/authprovider.dart';

class UserController extends GetxController {
  final GetStorage _box = GetStorage('GlobalStorage');
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

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
    } else {
      userModel.value = null;
    }
  }

  /// Cierra sesión, borra datos en Storage y redirige a /login
  Future<void> logout() async {
    await _authProvider.signOut();
    Get.offAllNamed('/login');
  }
}
