import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/home_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/home_page/widgets/balance_dialog.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/home_page/widgets/notifications_dialog.dart';
import 'dart:developer' as developer;

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  // Variable para almacenar el valor de monedas
  num coinBalance = 0;
  bool isLoading = true;
  bool isCollector = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  // Método para cargar datos de usuario y monedas
  Future<void> _loadUserData() async {
    try {
      final userController = Get.find<UserController>();
      isCollector = userController.userModel.value?.iscollector ?? true;
      
      // Si no es recolector, cargamos las monedas
      if (!isCollector) {
        isLoading = true;
        if (mounted) setState(() {});
        
        final homeController = Get.find<HomeController>();
        await homeController.fetchTotalCoins();
        coinBalance = homeController.totalCoins.value;
        
        isLoading = false;
        if (mounted) setState(() {});
      }
    } catch (e) {
      developer.log('Error al cargar datos de usuario: $e', name: 'HomeAppBar');
      isLoading = false;
      if (mounted) setState(() {});
    }
  }

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
                    '!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Ícono de balance
        // Balance Icon
        Builder(
          builder: (context) {
            // No mostrar si es recolector
            if (isCollector) {
              return const SizedBox.shrink();
            }
            
            return GestureDetector(
              onTap: () {
                developer.log('Tap en icono de balance detectado', name: 'BalanceIcon');
                // Mostramos el diálogo después que el build termine
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (_) => const BalanceDialog(),
                  ).catchError((error) {
                    developer.log('Error al mostrar diálogo: $error', name: 'BalanceIcon');
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 4),
                    isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          '${coinBalance.toInt()}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  ],
                ),
              ),
            );
          },
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
    );
  }
}
