// lib/modules/home/views/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/homescreen_controller.dart';

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

    void _showFloatingDialog(BuildContext context) {
      final residuos = [
        {
          "tipo": "Papel y cartón",
          "items": ["Papel", "Cartón"]
        },
        {
          "tipo": "Plástico",
          "items": ["Botellas", "Bolsas", "Grueso"]
        },
        {
          "tipo": "Vidrio",
          "items": ["Botella", "Frasco"]
        },
        {
          "tipo": "Metales",
          "items": ["Latas", "Cobre", "Chatarra"]
        },
        {
          "tipo": "Tetra Pack",
          "items": ["Envases"]
        },
      ];

      final kgControllers = <TextEditingController>[];
      final unitValues = <RxDouble>[];
      final totalKg = 0.0.obs;
      final totalMonedas = 0.0.obs;
      final totalBolsas = 0.obs;
      final segregadosCorrectamente = 0.obs;
      final selectedIcons = List.filled(residuos.length, false).obs;
      final selectedButtons = List.generate(
          residuos.length,
          (index) =>
              List.filled((residuos[index]["items"] as List).length, false)
                  .obs);
      final isKgFieldEnabled = List.filled(residuos.length, false).obs;

      for (var _ in residuos) {
        kgControllers.add(TextEditingController());
        unitValues.add(0.0.obs);
      }

      void _calculateTotals() {
        totalKg.value = 0.0;
        totalMonedas.value = 0.0;
        totalBolsas.value = 0;
        segregadosCorrectamente.value = 0;

        for (var i = 0; i < residuos.length; i++) {
          if (isKgFieldEnabled[i]) {
            // Si el tipo está activado
            final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
            unitValues[i].value = kg * 3; // Calcula el monto automático
            totalKg.value += kg;
            totalMonedas.value += unitValues[i].value;

            if (selectedIcons[i]) {
              segregadosCorrectamente.value += 1; // Incrementa el contador
            }
          }
        }

        // Sumar una sola bolsa por tipo de residuo
        totalBolsas.value = isKgFieldEnabled.where((enabled) => enabled).length;
      }

      for (var controller in kgControllers) {
        controller.addListener(_calculateTotals);
      }

      showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.8,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Tipo de Residuo",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...residuos.asMap().entries.map((entry) {
                      int index = entry.key;
                      var res = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                res["tipo"] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(() => IconButton(
                                    icon: Icon(
                                      Icons.shopping_bag,
                                      color: selectedIcons[index]
                                          ? const Color.fromARGB(
                                              255, 89, 217, 153)
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      // Verifica si se está seleccionando (no deseleccionando)
                                      if (!selectedIcons[index]) {
                                        // Cambiar el estado del ícono
                                        selectedIcons[index] =
                                            !selectedIcons[index];
                                        _calculateTotals();
                                        // Mostrar el diálogo de confirmación al seleccionar
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15), // Bordes redondeados
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFF31ADA0), // Fondo verde
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "¿El residuo esta en bolsa individual?",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Cerrar el diálogo
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF59D999),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 30,
                                                          vertical: 10,
                                                        ),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "Confirmar",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    const Text(
                                                      "Recuerda que se te asignará 2 monedas extras por segregar de manera correcta",
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Text(
                                                      "Será verificado por el recolector asignado",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        // Solo cambia el estado al deseleccionar, sin mostrar diálogo
                                        selectedIcons[index] =
                                            !selectedIcons[index];
                                        _calculateTotals();
                                      }
                                    },
                                  )),
                            ],
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: (res["items"] as List<String>)
                                .asMap()
                                .entries
                                .map((itemEntry) {
                              int itemIndex = itemEntry.key;
                              String item = itemEntry.value;
                              return Obx(() => ElevatedButton(
                                    onPressed: () {
                                      selectedButtons[index][itemIndex] =
                                          !selectedButtons[index][itemIndex];
                                      isKgFieldEnabled[index] =
                                          selectedButtons[index].contains(true);
                                      _calculateTotals();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedButtons[index]
                                              [itemIndex]
                                          ? const Color.fromARGB(
                                              255, 89, 217, 153)
                                          : const Color.fromARGB(
                                              255, 238, 238, 238),
                                    ),
                                    child: Text(item),
                                  ));
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.3,
                                child: Obx(() => TextField(
                                      controller: kgControllers[index],
                                      keyboardType: TextInputType.number,
                                      enabled: isKgFieldEnabled[index],
                                      decoration: InputDecoration(
                                        labelText: "Kg Aprox.",
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Monedas a Recibir",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  Obx(
                                    () => Center(
                                        child: Text(
                                      "${unitValues[index].value.toStringAsFixed(2)}",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Kg",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Obx(() =>
                                Text("${totalKg.value.toStringAsFixed(2)} Kg")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Monedas",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Obx(() => Text(
                                "${totalMonedas.value.toStringAsFixed(2)} Monedas")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("En bolsas individuales",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Obx(() => Text("${totalBolsas.value}")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Segregados correctamente",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Obx(() => Text("${segregadosCorrectamente.value}")),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Get.snackbar("Recolección Solicitada",
                            "Se procesará tu solicitud.");
                      },
                      child: Text("Enviar"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Imagen superior
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Image.asset(
              'lib/assets/home_rt.png',
              height: imageHeight,
              width: screenWidth * 0.75, // 90% del ancho
              fit: BoxFit.cover,
            ),
          ),

          // Botón "Solicitar Recolección"
          ElevatedButton(
            onPressed: () => _showFloatingDialog(context),
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
            width: screenWidth * 1,
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
