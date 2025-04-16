import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/incentives_controller.dart';

class IncentivesScreen extends GetView<IncentivesController> {
  const IncentivesScreen({Key? key}) : super(key: key);

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
                  itemCount: incentives.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.55,
                  ),
                  itemBuilder: (context, index) {
                    final inc = incentives[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF31ADA0), Color(0xFF59D999)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Imagen del incentivo
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                inc.image,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 140,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 140,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Contenido del incentivo
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nombre y precio
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          inc.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "${inc.price} \$",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Descripción corta
                                  Text(
                                    inc.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Al presionar CANJEAR, mostramos el diálogo
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Sección de monedas del usuario (por ahora estática o ejemplo)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .monetization_on,
                                                            color: Color(
                                                                0xFF31ADA0),
                                                            size: 30,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          // Texto con las monedas disponibles (harás tu lógica real para mostrarlo en la UI)
                                                          const Text(
                                                            "150 Monedas",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      // Imagen del producto
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                          inc.image,
                                                          height: 140,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              height: 140,
                                                              color: Colors
                                                                  .grey[300],
                                                              child: const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 60,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            );
                                                          },
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return const SizedBox(
                                                              height: 140,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      // Nombre y costo
                                                      Text(
                                                        inc.name,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "Costo: ${inc.price} monedas",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      // Descripción
                                                      Text(
                                                        inc.description,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      const Divider(height: 30),
                                                      // Proceso a seguir
                                                      const Text(
                                                        "Proceso para recibir tu premio:",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      const Text(
                                                        "- Una vez confirmado el canje, se descontarán las monedas de tu cuenta.\n"
                                                        "- El equipo de ReciclaTarapoto te contactará en un plazo de 48 horas.\n"
                                                        "- Deberás acercarte a nuestras oficinas con tu DNI para recoger el premio.",
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      // Botón de confirmación
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                "Cerrar"),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              // Aquí tu lógica de confirmación:
                                                              // Llamar al método del controller
                                                              await controller
                                                                  .redeemIncentive(
                                                                      inc);

                                                              // Cerrar el diálogo
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF31ADA0),
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                            child: const Text(
                                                                "Confirmar Canje"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color(0xFF31ADA0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "CANJEAR",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
