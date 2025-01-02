// lib/modules/home/views/incentives_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/incentives_controller.dart';

// Asegúrate de que tu controlador se inyecte en algún lugar,
// por ejemplo en un binding o usando Get.put(IncentivesController()).

class IncentivesScreen extends GetView<IncentivesController> {
  const IncentivesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usaremos un Obx() para escuchar los cambios en tiempo real
    // de la lista incentivesList en nuestro controller.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // Ajusta la UI a tu gusto
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            const Text(
              "Incentivos Disponibles",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 102, 102, 102),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Obx(() {
                final incentives = controller.incentivesList;
                if (incentives.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay incentivos disponibles.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: incentives.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    final inc = incentives[index];
                    return Card(
                      color: const Color.fromRGBO(49, 173, 161, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 9.0),
                      child: Column(
                        children: [
                          // Mostramos la imagen desde la URL de Firestore
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              inc.image,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.white,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        inc.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              221, 255, 255, 255),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "${inc.price} \$",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  inc.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Lógica de canje o lo que necesites hacer.
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(89, 217, 153, 1),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("CANJEAR"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
