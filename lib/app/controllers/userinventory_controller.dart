// lib/app/controllers/userinventory_controller.dart

import 'package:get/get.dart';

import '../data/models/usermodel.dart';
import '../data/provider/userinventory_provider.dart';

class UserinventoryController extends GetxController {
  final UserInventoryProvider _userProvider = UserInventoryProvider();

  // Stream de usuarios que NO son recolectores
  late final Stream<List<UserModel>> usersStream;

  @override
  void onInit() {
    super.onInit();
    // Inicializamos el stream
    usersStream = _userProvider.getUsers();
  }
}
