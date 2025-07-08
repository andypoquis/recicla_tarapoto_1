import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/home_page/widgets/notifications_dialog.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Logo
          Image.asset(
            'lib/assets/logo_completo.png',
            height: 39,
          ),
        ],
      ),
      actions: [
        // Ícono de notificaciones
        Transform.translate(
          offset: const Offset(-12, 0),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.white,
                iconSize: 33,
                onPressed: () {
                  // Mostramos el diálogo de notificaciones
                  showDialog(
                    context: context,
                    builder: (_) => NotificationsDialog(),
                  );
                },
              ),
              Positioned(
                right: 0,
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
              ),
            ],
          ),
        ),
        // Ícono de balance
        Obx(() {
          final userController = Get.find<UserController>();
          if (userController.userModel.value?.iscollector == true) {
            return const SizedBox.shrink(); // No mostrar si es recolector
          }
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 4),
                Text(
                  '${userController.currentCoinsBalance.value}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        }),
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
    );
  }
}
