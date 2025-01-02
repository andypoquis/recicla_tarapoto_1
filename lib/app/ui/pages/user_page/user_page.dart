// lib/modules/home/views/user_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({Key? key}) : super(key: key);

  Widget _buildStatCard(String title, String value, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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
    final screenHeight = MediaQuery.of(context).size.height;

    final avatarRadius = screenWidth * 0.18;
    final iconSize = avatarRadius * 1.5;
    final statCardWidth = screenWidth * 0.4;
    final fontSizeTitle = screenWidth * 0.05;
    final fontSizeSubtitle = screenWidth * 0.035;

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          // Escuchamos los cambios en userModel
          final userData = controller.userModel.value;

          // Si userData es null, mostramos un mensaje
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

          // Si hay userData, mostramos la UI con sus datos
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de perfil
                Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: const Color.fromARGB(255, 49, 173, 160),
                      child: Icon(
                        Icons.person,
                        size: iconSize,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),

                    // OJO: Aquí usamos Expanded en lugar de solo Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userData.name} ${userData.lastname}',
                            style: TextStyle(
                              fontSize: fontSizeSubtitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'DNI: ${userData.dni}',
                            style: TextStyle(fontSize: fontSizeSubtitle),
                          ),
                          Text(
                            'Telf: ${userData.phoneNumber}',
                            style: TextStyle(fontSize: fontSizeSubtitle),
                          ),
                          Text(
                            'Calle: ${userData.address}',
                            style: TextStyle(fontSize: fontSizeSubtitle),
                          ),
                          Text(
                            'Tipo: ${userData.typeUser.join(", ")}',
                            style: TextStyle(fontSize: fontSizeSubtitle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.03),

                // Sección de estadísticas
                Text(
                  'Mis Aportes:',
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 90.0,
                  child: _buildStatCard(
                    'Total de Residuos Reciclados',
                    '1000Kg',
                    Colors.green.shade300,
                    double.infinity,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      'Más reciclado',
                      'Plástico',
                      Colors.green.shade300,
                      statCardWidth,
                    ),
                    _buildStatCard(
                      'Recolecciones',
                      '85',
                      Colors.green.shade300,
                      statCardWidth,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                // Sección de info del recolector
                Text(
                  'Mi Recolector',
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Nombre Completo: Wilder Arévalo',
                  style: TextStyle(fontSize: fontSizeSubtitle),
                ),
                Text(
                  'Asociación: Nuevo Amanecer',
                  style: TextStyle(fontSize: fontSizeSubtitle),
                ),
                Text(
                  'Teléfono: 971248365',
                  style: TextStyle(fontSize: fontSizeSubtitle),
                ),
                Text(
                  'Horario: Miércoles de 7am a 3.30pm',
                  style: TextStyle(fontSize: fontSizeSubtitle),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
