// Este archivo representa la pantalla de incentivos.
// Importamos las librerías necesarias para la construcción de la UI y el uso de GetX.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/incentives_controller.dart';

// Esta clase extiende GetView para asociar la vista con el controlador IncentivesController.
class IncentivesScreen extends GetView<IncentivesController> {
  const IncentivesScreen({Key? key}) : super(key: key);

  // Método principal que construye la interfaz de usuario.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estructura principal de la pantalla.
      body: Padding(
        padding:
            const EdgeInsets.all(8.0), // Espaciado alrededor de toda la vista.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Alineación de los elementos en el eje horizontal.
          children: [
            const SizedBox(height: 14), // Espaciado superior.
            const Text(
              "Incentivos Disponibles", // Título principal de la pantalla.
              style: TextStyle(
                fontSize: 24, // Tamaño de la fuente.
                fontWeight: FontWeight.w500, // Grosor de la fuente.
                color: Color.fromARGB(255, 102, 102, 102), // Color del texto.
              ),
            ),
            const SizedBox(
                height: 8.0), // Espaciado entre el título y el contenido.
            Expanded(
              // Widget para ocupar el espacio restante en la pantalla.
              child: Obx(() {
                // Obx permite reaccionar automáticamente a cambios en variables reactivas del controlador.
                final incentives = controller.incentivesList;
                if (incentives.isEmpty) {
                  // Mostrar un mensaje si la lista de incentivos está vacía.
                  return const Center(
                    child: Text(
                      'No hay incentivos disponibles.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // GridView.builder crea una cuadrícula dinámica basada en los incentivos.
                return GridView.builder(
                  itemCount:
                      incentives.length, // Número de elementos en la lista.
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Número de columnas en la cuadrícula.
                    crossAxisSpacing:
                        10.0, // Espaciado horizontal entre columnas.
                    mainAxisSpacing: 1.0, // Espaciado vertical entre filas.
                    childAspectRatio:
                        0.46, // Relación de aspecto de los elementos.
                  ),
                  itemBuilder: (context, index) {
                    final inc = incentives[index]; // Elemento actual.
                    return Card(
                      color: const Color.fromRGBO(
                          49, 173, 161, 1), // Color de fondo de la tarjeta.
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Bordes redondeados.
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 9.0), // Espaciado vertical entre tarjetas.
                      child: Column(
                        children: [
                          // Imagen del incentivo cargada desde una URL.
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              inc.image, // URL de la imagen.
                              height: 200, // Altura de la imagen.
                              width: double
                                  .infinity, // Ocupa todo el ancho disponible.
                              fit: BoxFit
                                  .cover, // Ajusta la imagen al tamaño del contenedor.
                              errorBuilder: (context, error, stackTrace) {
                                // Mostrar un ícono si la carga de la imagen falla.
                                return const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.white,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                // Mostrar un indicador de carga mientras se descarga la imagen.
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                          Padding(
                            // Contenido de la tarjeta (nombre, descripción y botón).
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
                                        inc.name, // Nombre del incentivo.
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              221, 255, 255, 255),
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Limita el texto a una línea.
                                      ),
                                    ),
                                    Text(
                                      "${inc.price} \$", // Precio del incentivo.
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: 4), // Espaciado entre elementos.
                                Text(
                                  inc.description, // Descripción del incentivo.
                                  maxLines:
                                      3, // Número máximo de líneas para mostrar.
                                  overflow: TextOverflow
                                      .ellipsis, // Texto truncado con "..."
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                    height: 6), // Espaciado antes del botón.
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Lógica al presionar el botón (canje del incentivo).
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          89, 217, 153, 1), // Color del botón.
                                      foregroundColor: Colors
                                          .white, // Color del texto en el botón.
                                    ),
                                    child: const Text(
                                        "CANJEAR"), // Texto del botón.
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
