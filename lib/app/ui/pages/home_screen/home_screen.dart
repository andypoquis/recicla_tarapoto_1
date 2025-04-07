import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Asegúrate de importar tu HomeScreenController
import 'package:recicla_tarapoto_1/app/controllers/homescreen_controller.dart';
// Importa también tu UserController para acceder al userModel
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';
import 'package:recicla_tarapoto_1/app/data/models/residue_item.dart';
// Modelos
import 'package:recicla_tarapoto_1/app/data/models/waste_collection.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({Key? key}) : super(key: key);

  //------------------------------------------------------------------
  // 1. Diálogo de confirmación final (resumen):
  //------------------------------------------------------------------
  void _showConfirmationDialog(
    BuildContext context, {
    required List<Map<String, dynamic>> resumenResiduos,
    required double totalKg,
    required double totalMonedas,
    required int totalBolsas,
    required int segregadosCorrectamente,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta el tamaño
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                const Text(
                  "Resumen de Solicitud",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Listado de cada residuo seleccionado
                if (resumenResiduos.isEmpty)
                  const Text("No seleccionaste ningún residuo.")
                else
                  ...resumenResiduos.map((res) {
                    final tipo = res["tipo"];
                    final kg = res["kg"];
                    final bolsa = res["bolsa"] == true ? "Sí" : "No";
                    final items = (res["items"] as List).join(", ");
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• $tipo",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text("   Items: $items"),
                          Text("   Cantidad: $kg Kg"),
                          Text("   Bolsa individual: $bolsa"),
                        ],
                      ),
                    );
                  }),

                const Divider(thickness: 1.2),
                // Totales
                Text("Total Kg: $totalKg"),
                Text("Total Monedas: $totalMonedas"),
                Text("En bolsas individuales: $totalBolsas"),
                Text("Segregados correctamente: $segregadosCorrectamente"),
                const SizedBox(height: 16),

                // Botones "Cancelar" y "Confirmar"
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(ctx).pop(); // cierra resumen sin confirmar
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Confirmar"),
                      onPressed: () async {
                        Navigator.of(ctx).pop();

                        // (1) Obtenemos los datos del usuario (dirección, uid, etc.)
                        final userController = Get.find<UserController>();
                        final userData = userController.userModel.value;
                        if (userData == null) {
                          Get.snackbar(
                            "Error",
                            "No se encontró información de usuario.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // (2) Mapeamos los residuos al modelo ResidueItem
                        final List<ResidueItem> residueItems =
                            resumenResiduos.map((res) {
                          final double kg = res["kg"] as double;
                          // asumiendo que 1 kg = 3 monedas:
                          final double coins = kg * 3;

                          return ResidueItem(
                            approxKg: kg,
                            coinsPerType: coins.toStringAsFixed(1),
                            individualBag: res["bolsa"] as bool,
                            selectedItems:
                                (res["items"] as List).cast<String>(),
                            type: res["tipo"] as String,
                          );
                        }).toList();

                        // (3) Construimos nuestro WasteCollectionModel
                        // isRecycled en este punto podría ser false
                        // (asumiendo que aún no está reciclado, apenas se solicita)
                        final wasteCollection = WasteCollectionModel(
                          id: '', // se asignará automáticamente
                          address: userData.address,
                          isRecycled: false,
                          totalBags: totalBolsas.toDouble(),
                          totalCoins: totalMonedas,
                          totalKg: totalKg,
                          correctlySegregated: segregadosCorrectamente,
                          residues: residueItems,
                          // Referencia al usuario en Firestore (colección 'users')
                          userReference: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userData.uid),
                          date: DateTime.now(),
                        );

                        // (4) Llamamos al método en el controller para guardar en Firestore
                        await controller.createWasteCollection(wasteCollection);

                        // (5) Notificamos al usuario
                        Get.snackbar(
                          "Solicitud Enviada",
                          "Tu solicitud ha sido confirmada y guardada.",
                          backgroundColor: const Color(0xFF59D999),
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //------------------------------------------------------------------
  // 2. Diálogo de marcar bolsa individual (igual que antes)
  //------------------------------------------------------------------
  void _showBolsaDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF31ADA0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "¿El residuo está en bolsa individual?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59D999),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Recuerda que se te asignarán 2 monedas extras por segregar de manera correcta.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Será verificado por el recolector asignado.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------------------------------------------------------
  // 3. Helpers de Totales e Items
  //------------------------------------------------------------------
  Widget _buildRowTotal(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTotales(
    RxDouble totalKg,
    RxDouble totalMonedas,
    RxInt totalBolsas,
    RxInt segregadosCorrectamente,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowTotal("Total Kg", "${totalKg.value.toStringAsFixed(2)} Kg"),
          _buildRowTotal(
              "Total Monedas", "${totalMonedas.value.toStringAsFixed(2)}"),
          _buildRowTotal("En bolsas individuales", "${totalBolsas.value}"),
          _buildRowTotal(
              "Segregados correctamente", "${segregadosCorrectamente.value}"),
        ],
      ),
    );
  }

  Widget _buildResiduoItem(
    int index,
    String tipo,
    List<String> items,
    RxList<bool> selectedIcons,
    List<RxList<bool>> selectedButtons,
    RxList<bool> isKgFieldEnabled,
    List<TextEditingController> kgControllers,
    List<RxDouble> unitValues,
    double screenWidth,
    Function calculateTotals,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado: tipo de residuo + ícono bolsa
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tipo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Obx(
              () => IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                  color: selectedIcons[index]
                      ? const Color(0xFF59D999)
                      : Colors.grey.shade400,
                ),
                onPressed: () {
                  if (!selectedIcons[index]) {
                    selectedIcons[index] = true;
                    calculateTotals();
                    _showBolsaDialog();
                  } else {
                    selectedIcons[index] = false;
                    calculateTotals();
                  }
                },
              ),
            ),
          ],
        ),
        // Botones de ítems
        Wrap(
          spacing: 8.0,
          children: items.asMap().entries.map((itemEntry) {
            int itemIndex = itemEntry.key;
            String item = itemEntry.value;
            return Obx(
              () => ElevatedButton(
                onPressed: () {
                  selectedButtons[index][itemIndex] =
                      !selectedButtons[index][itemIndex];
                  isKgFieldEnabled[index] =
                      selectedButtons[index].contains(true);
                  calculateTotals();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedButtons[index][itemIndex]
                      ? const Color(0xFF59D999)
                      : Colors.grey.shade200,
                  foregroundColor: selectedButtons[index][itemIndex]
                      ? Colors.white
                      : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(item),
              ),
            );
          }).toList(),
        ),
        // Campo para ingresar Kg + Muestra de monedas
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth * 0.3,
              child: Obx(
                () => TextField(
                  controller: kgControllers[index],
                  keyboardType: TextInputType.number,
                  enabled: isKgFieldEnabled[index],
                  decoration: InputDecoration(
                    labelText: "Kg Aprox.",
                    labelStyle: TextStyle(
                      color:
                          isKgFieldEnabled[index] ? Colors.black : Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                    disabledBorder: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Monedas a Recibir",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Obx(
                  () => Text(
                    "${unitValues[index].value.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  //------------------------------------------------------------------
  // 4. Diálogo principal de "Solicitar Recolección"
  //------------------------------------------------------------------
  void _showFloatingDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Definimos cada tipo de residuo y sus items
    final residuos = [
      {
        "tipo": "Papel y Cartón",
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

    // Declaramos variables reactivas para controlar selección y totales
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
          List.filled((residuos[index]["items"] as List).length, false).obs,
    );
    final isKgFieldEnabled = List.filled(residuos.length, false).obs;

    // Creamos un controller y un valor unitValue para cada tipo de residuo
    for (var _ in residuos) {
      kgControllers.add(TextEditingController());
      unitValues.add(0.0.obs);
    }

    // Recalcula totales cuando algo cambia
    void _calculateTotals() {
      totalKg.value = 0.0;
      totalMonedas.value = 0.0;
      totalBolsas.value = 0;
      segregadosCorrectamente.value = 0;

      for (var i = 0; i < residuos.length; i++) {
        if (isKgFieldEnabled[i]) {
          final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
          // 1 Kg => 3 monedas (ejemplo)
          unitValues[i].value = kg * 3;
          totalKg.value += kg;
          totalMonedas.value += unitValues[i].value;

          if (selectedIcons[i]) {
            segregadosCorrectamente.value += 1;
          }
        }
      }

      // Cada tipo de residuo activado cuenta como 1 bolsa
      totalBolsas.value = isKgFieldEnabled.where((enabled) => enabled).length;
    }

    // Listeners para recalcular si se modifican Kg en cualquier TextField
    for (var controller in kgControllers) {
      controller.addListener(_calculateTotals);
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                // Encabezado
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF31ADA0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Solicitud de Recolección",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Contenido principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Selecciona el tipo de residuo y la cantidad estimada (Kg). "
                          "Si lo estás separando en bolsas individuales, ¡no olvides marcar el ícono!",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 15),
                        // Construye cada "tipo de residuo"
                        ...residuos.asMap().entries.map((entry) {
                          int i = entry.key;
                          var res = entry.value;
                          return _buildResiduoItem(
                            i,
                            res["tipo"] as String,
                            res["items"] as List<String>,
                            selectedIcons,
                            selectedButtons,
                            isKgFieldEnabled,
                            kgControllers,
                            unitValues,
                            screenWidth,
                            _calculateTotals,
                          );
                        }).toList(),

                        const Divider(thickness: 1.2),
                        _buildTotales(totalKg, totalMonedas, totalBolsas,
                            segregadosCorrectamente),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // Botón final
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // 1) Cerramos este diálogo
                      Navigator.of(ctx).pop();

                      // 2) Generamos un listado de lo que se seleccionó para mostrarlo
                      final List<Map<String, dynamic>> resumen = [];
                      for (var i = 0; i < residuos.length; i++) {
                        if (isKgFieldEnabled[i]) {
                          final tipo = residuos[i]["tipo"];
                          final kg =
                              double.tryParse(kgControllers[i].text) ?? 0.0;
                          final bolsa = selectedIcons[i];
                          // Recolectamos también los items marcados
                          final selectedItems = <String>[];
                          for (var j = 0; j < selectedButtons[i].length; j++) {
                            if (selectedButtons[i][j]) {
                              selectedItems.add(
                                  (residuos[i]["items"] as List<String>)[j]);
                            }
                          }
                          resumen.add({
                            "tipo": tipo,
                            "kg": kg,
                            "bolsa": bolsa,
                            "items": selectedItems,
                          });
                        }
                      }

                      // 3) Mostramos el diálogo de confirmación/resumen
                      _showConfirmationDialog(
                        context,
                        resumenResiduos: resumen,
                        totalKg: totalKg.value,
                        totalMonedas: totalMonedas.value,
                        totalBolsas: totalBolsas.value,
                        segregadosCorrectamente: segregadosCorrectamente.value,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF59D999),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 14),
                    ),
                    child: const Text(
                      "Enviar Solicitud",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //------------------------------------------------------------------
  // 5. Método build principal
  //------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageHeight = screenHeight * 0.3; // Imagen ~30% alto de pantalla
    final carouselHeight = screenHeight * 0.25; // Carrusel ~25% alto

    return SingleChildScrollView(
      child: Column(
        children: [
          // Imagen superior
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Image.asset(
              'lib/assets/home_rt.png',
              height: imageHeight,
              width: screenWidth * 0.75,
              fit: BoxFit.cover,
            ),
          ),

          // Botón "Solicitar Recolección"
          ElevatedButton(
            onPressed: () => _showFloatingDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 89, 217, 153),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Solicitar Recolección',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
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
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Carrusel
          SizedBox(
            height: carouselHeight,
            width: screenWidth,
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
                itemCount: images.length * 10, // carrusel "infinito"
                itemBuilder: (context, index) {
                  final imageModel = images[index % images.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageModel.url,
                        fit: BoxFit.cover,
                        width: screenWidth * 0.3,
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
