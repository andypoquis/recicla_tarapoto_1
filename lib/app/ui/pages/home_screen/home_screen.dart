// lib/modules/home/views/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/homescreen_controller.dart';
// Asegúrate de importar el controlador con la ruta correcta.

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho y alto de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Definimos proporciones para las secciones
    final imageHeight =
        screenHeight * 0.3; // 30% de la pantalla de alto para la imagen
    final carouselHeight = screenHeight * 0.25; // 25% para el carrusel

    return SingleChildScrollView(
      child: Column(
        children: [
          // Imagen superior
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Image.asset(
              'lib/assets/home_rt.png',
              height: imageHeight,
              width: screenWidth * 0.9, // 90% del ancho de la pantalla
              fit: BoxFit.cover,
            ),
          ),

          // Botón "Solicitar Recolección"
          ElevatedButton(
            onPressed: () {
              // Acción para solicitar recolección
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 89, 217, 153),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1, // 10% del ancho
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Solicitar Recolección',
              style: TextStyle(
                fontSize: screenWidth * 0.05, // 5% del ancho
                color: Colors.white,
              ),
            ),
          ),

          // Texto "Participaciones de la Semana"
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Participaciones de la Semana',
              style: TextStyle(
                fontSize: screenWidth * 0.05, // 5% del ancho
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Carrusel
          SizedBox(
            height: carouselHeight,
            width: screenWidth * 0.9,
            child: Obx(() {
              final images = controller.carouselImages;
              if (images.isEmpty) {
                return const Center(
                  child: Text('No hay imágenes para el carrusel'),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                // Para simular un carrusel infinito, multiplicamos el número de items
                itemCount: images.length * 10,
                itemBuilder: (context, index) {
                  final imageModel = images[index % images.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageModel.url,
                        fit: BoxFit.cover,
                        width:
                            screenWidth * 0.3, // Ajusta el ancho de cada item
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
