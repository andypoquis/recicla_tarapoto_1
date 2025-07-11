import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_stats_controller.dart';

class UserScreen extends GetView<UserController> {
  UserScreen({Key? key}) : super(key: key);

  // Instanciar el controlador de estadísticas a nivel de clase
  final UserStatsController statsController = UserStatsController();
  
  @override
  Widget build(BuildContext context) {
    // Registrar el controlador si no está registrado ya
    if (!Get.isRegistered<UserStatsController>()) {
      Get.put(statsController);
    }
    
    // Inicializar y forzar la carga de estadísticas cuando se construye la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar datos reales desde Firebase
      statsController.loadUserStats();
      print('🔄 Forzando carga de estadísticas reales desde Firebase');
    });

    return Scaffold(
      body: Obx(() {
        final userData = controller.userModel.value;

        if (userData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Si tenemos un usuario collector (para el usuario NO recolector)
        final collectorData = controller.collectorModel.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Sección del header con avatar y datos básicos
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF31ADA0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            userData.name.isNotEmpty
                                ? userData.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF31ADA0),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () => controller.logout(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${userData.name} ${userData.lastname}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Usuario Registrado",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección de Mis Aportes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mis Aportes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.money, color: Color(0xFF31ADA0)),
                            const SizedBox(width: 4),
                            Text(
                              '${controller.totalCoinsEarnedFromRecycling.value}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF31ADA0),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Botón para actualizar estadísticas
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF31ADA0)),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'Actualizar estadísticas',
                              onPressed: () {
                                // Actualizar estadísticas
                                statsController.refreshStats();
                                Get.snackbar(
                                  'Actualizando', 
                                  'Cargando datos más recientes...',
                                  backgroundColor: Colors.green.withOpacity(0.2),
                                  duration: const Duration(seconds: 2)
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Información de reciclaje
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Residuos reciclados
                          GetX<UserStatsController>(
                            init: statsController,
                            builder: (controller) {
                              return Row(
                                children: [
                                  const Icon(Icons.recycling, color: Color(0xFF31ADA0)),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Residuos Reciclados:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  controller.isLoading.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF31ADA0),
                                        ),
                                      )
                                    : Text(
                                        '${controller.totalKgReciclados.value.toStringAsFixed(1)} Kg',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF31ADA0),
                                        ),
                                      ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GetX<UserStatsController>(
                                  init: statsController,
                                  builder: (controller) {
                                    return Row(
                                      children: [
                                        const Icon(Icons.card_giftcard,
                                            size: 20, color: Color(0xFF31ADA0)),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Incentivos:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        controller.isLoading.value
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF31ADA0),
                                              ),
                                            )
                                          : Text(
                                              '${statsController.totalIncentivosCanjeados.value}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF31ADA0),
                                              ),
                                            ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: GetX<UserStatsController>(
                                  init: statsController,
                                  builder: (controller) {
                                    return Row(
                                      children: [
                                        const Icon(Icons.repeat,
                                            size: 20, color: Color(0xFF31ADA0)),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Recolecciones:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        controller.isLoading.value
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF31ADA0),
                                              ),
                                            )
                                          : Text(
                                              '${statsController.totalRecolecciones.value}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF31ADA0),
                                              ),
                                            ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección Mi Recolector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mi Recolector',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (collectorData != null)
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Color(0xFF31ADA0)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${collectorData.name} ${collectorData.lastname}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Icon(Icons.group, color: Color(0xFF31ADA0)),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Asociación: Nuevo Amanecer',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      color: Color(0xFF31ADA0)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Teléfono: ${collectorData.phoneNumber}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: Color(0xFF31ADA0)),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Horario: Miércoles de 7 a 3:30pm',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child:
                              Text('No se encontró información del recolector'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
