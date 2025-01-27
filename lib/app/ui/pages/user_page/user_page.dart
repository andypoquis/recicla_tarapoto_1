import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({Key? key}) : super(key: key);

  Widget _buildStatCard(String title, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF59D999), Color(0xFF31ADA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = screenWidth * 0.16;

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          final userData = controller.userModel.value;

          if (userData == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No hay usuario registrado en el Storage',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de perfil
                Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: const Color(0xFF31ADA0),
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userData.name} ${userData.lastname}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('DNI: ${userData.dni}'),
                          Text('Telf: ${userData.phoneNumber}'),
                          Text('Calle: ${userData.address}'),
                          Text('Tipo: ${userData.typeUser.join(", ")}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sección de estadísticas
                const Text(
                  'Mis Aportes:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  'Total de Residuos Reciclados',
                  '1000Kg',
                  double.infinity,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      'Más reciclado',
                      'Plástico',
                      screenWidth * 0.43,
                    ),
                    _buildStatCard(
                      'Recolecciones',
                      '85',
                      screenWidth * 0.43,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sección de info del recolector
                const Text(
                  'Mi Recolector:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Nombre Completo: Wilder Arévalo'),
                Text('Asociación: Nuevo Amanecer'),
                Text('Teléfono: 971248365'),
                Text('Horario: Miércoles de 7am a 3.30pm'),
              ],
            ),
          );
        }),
      ),
    );
  }
}
