// lib/modules/home/controllers/user_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/data/models/usermodel.dart';

class UserController extends GetxController {
  // Instancia de GetStorage
  final GetStorage _box = GetStorage('GlobalStorage');

  // Observable para almacenar el UserModel
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    // Leemos el Map guardado en 'userData'
    final Map<String, dynamic>? userMap = _box.read('userData');
    if (userMap != null) {
      userModel.value = UserModel.fromFirestore(userMap);
    } else {
      userModel.value = null;
    }
  }
}
