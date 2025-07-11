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
        // Pre-calculate values with new names for clarity and to ensure correct types
        final int bonusCoinsFromSegregados = segregadosCorrectamente * 5;
        final double finalTotalMonedasARecibir =
            totalMonedas + bonusCoinsFromSegregados.toDouble();

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
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF59D999), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• $tipo",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF31ADA0),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Items: $items"),
                          Text("Cantidad: $kg Kg"),
                          Text("Bolsa individual: $bolsa"),
                        ],
                      ),
                    );
                  }),

                const Divider(thickness: 1.2),
                // Totales (ahora scrollable y adaptable)
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total de Residuos en Kg: $totalKg", softWrap: true),
                        Text("Total Monedas por Residuos: $totalMonedas", softWrap: true),
                        Text("Segregados Correctamente (cantidad): $segregadosCorrectamente", softWrap: true),
                        Text("Monedas por Segregación (+5 c/u): $bonusCoinsFromSegregados", softWrap: true),
                        Text("Monedas Totales a Recibir: $finalTotalMonedasARecibir", softWrap: true),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

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
                          totalCoins:
                              totalMonedas + (segregadosCorrectamente * 5),
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
                "Recuerda que se te asignarán 5 monedas extras por segregar de manera correcta.",
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
          _buildRowTotal("Total de Residuos en Kg:",
              "${totalKg.value.toStringAsFixed(2)} Kg"),
          _buildRowTotal("Total Monedas por Residuos:",
              "${totalMonedas.value.toStringAsFixed(0)}"),
          _buildRowTotal("Segregados Correctamente (cantidad):",
              "${segregadosCorrectamente.value}"),
          _buildRowTotal("Monedas por Segregación (+5 c/u):",
              "${segregadosCorrectamente.value * 5}"),
          _buildRowTotal("Monedas Totales a Recibir:",
              "${totalMonedas.value + (segregadosCorrectamente.value * 5)}"),
        ],
      ),
    );
  }

  Widget _buildResiduoItem(
    Map<String, dynamic> residuo,
    int index,
    List<TextEditingController> kgControllers,
    RxList<bool> isKgFieldEnabled,
    List<RxDouble> unitValues,
    RxList<bool> selectedIcons,
    List<RxList<bool>> selectedButtons,
    List<RxBool> isKgFieldNotEmpty,
    VoidCallback calculateTotals,
    VoidCallback showBolsaDialog,
    double screenWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado: tipo de residuo + ícono bolsa
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              residuo["tipo"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            // Icono de bolsa usando el controlador para la activación
            Obx(() {
              // Se ejecuta cada vez que cambia updateUI
              controller.updateUI.value;
              
              // Verificamos si hay texto en el campo y si algún botón está seleccionado
              final bool hasText = kgControllers[index].text.isNotEmpty;
              final bool anyButtonSelected = selectedButtons[index].contains(true);
              final bool isEnabled = hasText && anyButtonSelected;
              
              // Si no hay botones seleccionados, asegurémonos de que el ícono esté gris
              if (!anyButtonSelected && selectedIcons[index]) {
                selectedIcons[index] = false;
                calculateTotals();
              }
              
              return IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                  color: isEnabled
                      ? (selectedIcons[index]
                          ? const Color(0xFF59D999)  // Verde cuando está seleccionado
                          : Colors.grey)
                      : Colors.grey.withOpacity(0.5), // Gris cuando deshabilitado
                ),
                // El botón solo se activa si hay texto y algún botón seleccionado
                onPressed: isEnabled
                    ? () {
                        selectedIcons[index] = !selectedIcons[index];
                        if (selectedIcons[index]) {
                          _showBolsaDialog();
                        }
                        calculateTotals();
                      }
                    : null,
              );
            }),
          ],
        ),
        // Botones de ítems
        Wrap(
          spacing: 8.0,
          children: (residuo["items"] as List<String>).asMap().entries.map((entry) {
            final itemIndex = entry.key;
            final item = entry.value;
            return Obx(
              () => ElevatedButton(
                onPressed: () {
                  // Cambiar el estado del botón actual
                  selectedButtons[index][itemIndex] = !selectedButtons[index][itemIndex];
                  
                  // Verificar si todos los tipos de residuos están desmarcados
                  final anySelected = selectedButtons[index].contains(true);
                  
                  // Si ningún botón está seleccionado, reiniciar todo
                  if (!anySelected) {
                    print('Todos los ítems desmarcados para ${residuo["tipo"]}. Reiniciando valores...');
                    
                    // Deshabilitar el campo de kg
                    isKgFieldEnabled[index] = false;
                    
                    // Limpiar el campo de kilos
                    kgControllers[index].clear();
                    
                    // Reiniciar el ícono de segregación correcta
                    selectedIcons[index] = false;
                    
                    // Actualizar los valores unitarios
                    unitValues[index].value = 0.0;
                    
                    // Forzar un rebuild para actualizar la UI
                    controller.refreshUI();
                  } else {
                    // Si hay al menos un botón seleccionado, habilitar el campo
                    isKgFieldEnabled[index] = true;
                  }
                  
                  // Recalcular los totales
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
              width: 100,
              child: Obx(
                () => TextField(
                  controller: kgControllers[index],
                  keyboardType: TextInputType.number,
                  enabled: isKgFieldEnabled[index],
                  onChanged: (value) {
                    // Notificar al controlador que debe actualizar la UI
                    controller.refreshUI();
                    calculateTotals();
                  },
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
                    "${unitValues[index].toStringAsFixed(2)}",
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
    final isKgFieldNotEmpty =
        List.generate(residuos.length, (_) => false.obs);

    // Creamos un controller y un valor unitValue para cada tipo de residuo
    for (var _ in residuos) {
      kgControllers.add(TextEditingController());
      unitValues.add(0.0.obs);
    }

    // Recalcula totales cuando algo cambia
    void _calculateTotals() {
      print(
          "_calculateTotals CALLED - Timestamp: ${DateTime.now().toIso8601String()}");
      totalKg.value = 0.0;
      totalMonedas.value = 0.0;
      totalBolsas.value = 0;
      segregadosCorrectamente.value = 0;
      print(
          "  Initial segregadosCorrectamente.value: ${segregadosCorrectamente.value}");

      for (var i = 0; i < residuos.length; i++) {
        print(
            "  Looping for residue $i (${residuos[i]['tipo']}): isKgFieldEnabled=${isKgFieldEnabled[i]}, selectedIcon=${selectedIcons[i]}");
        if (isKgFieldEnabled[i]) {
          final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
          // 1 Kg => 3 monedas (ejemplo)
          unitValues[i].value = kg * 3;
          totalKg.value += kg;
          totalMonedas.value += unitValues[i].value;

          if (selectedIcons[i]) {
            segregadosCorrectamente.value += 1;
            print(
                "    Residue $i: selectedIcon is TRUE, incrementing segregadosCorrectamente. New value: ${segregadosCorrectamente.value}");
          }
        }
      }

      // Cada tipo de residuo activado cuenta como 1 bolsa
      totalBolsas.value = isKgFieldEnabled.where((enabled) => enabled).length;
      print(
          "  _calculateTotals FINISHED. Final segregadosCorrectamente.value: ${segregadosCorrectamente.value}, totalMonedas.value: ${totalMonedas.value}");
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
                          "Si lo estás separando en bolsas individuales, ¡no olvides marcar el ícono!, así recibiras unas monedas extras",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 15),
                        // Construye cada "tipo de residuo"
                        ...residuos.asMap().entries.map((entry) {
                          int i = entry.key;
                          var res = entry.value;
                          return _buildResiduoItem(
                            res,
                            i,
                            kgControllers,
                            isKgFieldEnabled,
                            unitValues,
                            selectedIcons,
                            selectedButtons,
                            isKgFieldNotEmpty,
                            _calculateTotals,
                            _showBolsaDialog,
                            screenWidth,
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
                    child: Stack(
                      children: [
                        // Imagen con marco dorado si es premiación
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: imageModel.tipo == 'premio'
                                  ? const Color(0xFFFFD700)
                                  : const Color.fromARGB(0, 81, 255, 0),
                              width: 4.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                // Imagen principal
                                Image.network(
                                  imageModel.url,
                                  fit: BoxFit.cover,
                                  width: screenWidth * 0.3,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),

                                // Texto en la parte inferior directamente sobre la imagen
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    color: const Color.fromRGBO(89, 217, 153, 1)
                                        .withOpacity(0.9),
                                    alignment: Alignment.center,
                                    child: Text(
                                      imageModel.tipo == 'premio'
                                          ? 'premio'
                                          : 'Participación',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Emoji distintivo arriba a la izquierda
                        Positioned(
                          top: -6,
                          left: 86,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              imageModel.tipo == 'premio' ? '🏆' : '🤝',
                              style: const TextStyle(fontSize: 21),
                            ),
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
    );
  }
}
