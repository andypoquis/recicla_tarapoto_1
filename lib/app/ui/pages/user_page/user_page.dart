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

          // Si tenemos un usuario collector (para el usuario NO recolector)
          final collectorData = controller.collectorModel.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Sección superior (header) con el avatar, icono de logout y datos básicos
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF31ADA0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      // Icono de logout alineado arriba a la derecha
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.exit_to_app),
                          color: Colors.white,
                          tooltip: 'Cerrar sesión',
                          onPressed: () {
                            controller.logout();
                          },
                        ),
                      ),
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFF31ADA0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${userData.name} ${userData.lastname}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Información rápida (DNI y teléfono)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.credit_card, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            'DNI: ${userData.dni}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.phone, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            userData.phoneNumber,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Sección de datos del usuario (dirección, tipo de usuario)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Color(0xFF31ADA0),
                            ),
                            title: const Text('Dirección'),
                            subtitle: Text(userData.address),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.person_pin_rounded,
                              color: Color(0xFF31ADA0),
                            ),
                            title: const Text('Tipo de Usuario'),
                            subtitle: Text(userData.typeUser.join(", ")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sección de estadísticas: Aportes, Residuos Reciclados, Recolecciones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mis Aportes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Total de Residuos Reciclados
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Residuos Reciclados',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    '1000 Kg',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF31ADA0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Más reciclado y Recolecciones
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: const [
                                        Text(
                                          'Material + reciclado',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Plástico',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF31ADA0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: const [
                                        Text(
                                          'Recolecciones',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '85',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF31ADA0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Sección de info del recolector (si el usuario actual NO es recolector)
                if (!userData.iscollector) ...[
                  const Text(
                    'Mi Recolector:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Si ya tenemos collectorData, lo mostramos:
                  if (collectorData != null) ...[
                    Text(
                        'Nombre Completo: ${collectorData.name} ${collectorData.lastname}'),
                    const Text('Asociación: Nuevo Amanecer'),
                    Text('Teléfono: ${collectorData.phoneNumber}'),
                    const Text('Horario: Miércoles de 7am a 3.30pm'),
                  ] else ...[
                    // Si collectorData == null (no se encontró recolector o falló consulta)
                    const Text('No se encontró información del recolector'),
                  ],
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
