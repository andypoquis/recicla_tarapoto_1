// lib/app/ui/pages/homecollector/homecollector_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/homecollector_controller.dart';
import '../../../data/models/waste_collection.dart';

class HomecollectorPage extends GetView<HomecollectorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recolecciones Pendientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<WasteCollectionModel>>(
                  stream: controller.wasteCollectionsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No hay recolecciones pendientes.'),
                      );
                    }
                    final wasteCollections = snapshot.data!;
                    return ListView.builder(
                      itemCount: wasteCollections.length,
                      itemBuilder: (context, index) {
                        final waste = wasteCollections[index];
                        return _buildListItem(waste, context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(WasteCollectionModel waste, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () => _showFloatingDialog(context, waste),
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 89, 217, 206),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            waste.address.isEmpty ? 'Sin dirección' : waste.address,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  /// Abre el diálogo y llena automáticamente los campos
  void _showFloatingDialog(BuildContext context, WasteCollectionModel waste) {
    // Define las categorías que quieres mostrar en tu UI
    // (puede ser 1:1 con los "type" que guardas en Firestore, o distinto).
    final uiResiduos = [
      {
        "type": "Papel y cartón",
        "selectedItems": ["Papel", "Cartón"]
      },
      {
        "type": "Plastico",
        "selectedItems": ["Bags", "Bottles", "Grueso"]
      },
      {
        "type": "Vidrio",
        "selectedItems": ["Botella", "Frasco"]
      },
      {
        "type": "Metales",
        "selectedItems": ["Latas", "Cobre", "Chatarra"]
      },
      {
        "type": "Tetra Pack",
        "selectedItems": ["Envases"]
      },
    ];

    // Controladores y reactividad
    final kgControllers = <TextEditingController>[];
    final unitValues = <RxDouble>[];
    final selectedIcons = <RxBool>[]; // para el ícono de bolsa
    final selectedButtons = <List<RxBool>>[]; // para los items

    // Observables para totales
    final totalKg = 0.0.obs;
    final totalMonedas = 0.0.obs;
    final totalBolsas = 0.obs;
    final segregadosCorrectamente = 0.obs;

    // 1. Inicializamos listas
    for (var i = 0; i < uiResiduos.length; i++) {
      kgControllers.add(TextEditingController());
      unitValues.add(0.0.obs);
      selectedIcons.add(false.obs);

      // Cada categoría puede tener N sub-items
      final itemsCount = (uiResiduos[i]["selectedItems"] as List).length;
      selectedButtons.add(List.generate(itemsCount, (_) => false.obs));
    }

    // 2. Sincronizamos la data de Firestore con la UI
    //    Buscamos si en waste.residues hay un ResidueItem cuyo "type"
    //    coincida con "tipo" (en tu BD p.e. "Plastic" vs. "Plástico"?).
    //    Aquí asumo que guardas en BD "Plástico" tal cual. Si usas "Plastic",
    //    puedes hacer un pequeño mapeo.
    for (var i = 0; i < uiResiduos.length; i++) {
      final tipoUI = uiResiduos[i]["type"] as String;

      // Buscamos en la lista de ResidueItem
      final found = waste.residues.firstWhereOrNull(
        (r) => r.type.toLowerCase() == tipoUI.toLowerCase(),
      );

      if (found != null) {
        // Llenamos el TextField de Kg
        kgControllers[i].text = found.approxKg.toString();
        // Llenamos unitValues con coinsPerType
        final coinsDouble = double.tryParse(found.coinsPerType) ?? 0.0;
        unitValues[i].value = coinsDouble;

        // Marcamos la bolsa si individualBag = true
        selectedIcons[i].value = found.individualBag;

        // Marcamos selectedButtons
        final itemsUI = uiResiduos[i]["selectedItems"] as List<String>;

        for (var idxItem = 0; idxItem < itemsUI.length; idxItem++) {
          final uiItem = itemsUI[idxItem];
          // Si en Firestore guardaste "Bottles" y en UI es "Botellas",
          // podrías necesitar un pequeño mapeo, p.e. "Bottles" -> "Botellas".
          // De lo contrario, asumo coincide tal cual (case sensitive).
          if (found.selectedItems.contains(uiItem)) {
            selectedButtons[i][idxItem].value = true;
          }
        }
      }
    }

    // 3. Función para recalcular totales cada vez que cambie algo
    void _calculateTotals() {
      double tmpKg = 0;
      double tmpMonedas = 0;
      int tmpBolsas = 0;
      int tmpSegregado = 0;

      for (var i = 0; i < uiResiduos.length; i++) {
        final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
        final coins = unitValues[i].value;
        // Si hay algún item seleccionado en esa categoría:
        final hasItemsSelected =
            selectedButtons[i].any((selected) => selected.value);

        if (hasItemsSelected) {
          tmpKg += kg;
          tmpMonedas += coins;
          // Si la bolsa está activa
          if (selectedIcons[i].value) {
            tmpSegregado++;
          }
          tmpBolsas++;
        }
      }

      totalKg.value = tmpKg;
      totalMonedas.value = tmpMonedas;
      totalBolsas.value = tmpBolsas;
      segregadosCorrectamente.value = tmpSegregado;
    }

    // 4. Listeners para cada kgController
    for (var i = 0; i < kgControllers.length; i++) {
      kgControllers[i].addListener(() {
        // Recalcula las monedas en base a tu lógica (si lo deseas)
        // Ej: unitValues[i].value = double.tryParse(kgControllers[i].text) * 3
        final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
        unitValues[i].value = kg * 3;

        _calculateTotals();
      });
    }

    // 5. Mostramos el diálogo
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.9,
            height: MediaQuery.of(ctx).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Recolección Seleccionada: ${waste.address}",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  // Podrías mostrar más info, p.e.:
                  Text("TotalKg Firestore: ${waste.totalKg}"),
                  Text("TotalCoins Firestore: ${waste.totalCoins}"),
                  // ...

                  SizedBox(height: 10),
                  Text("Tipo de Residuo",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Generamos la interfaz
                  ...uiResiduos.asMap().entries.map((entry) {
                    final i = entry.key;
                    final res = entry.value;
                    final tipo = res["type"] as String;
                    final items = res["selectedItems"] as List<String>;

                    return Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fila: nombre tipo + ícono de bolsa
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tipo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_bag,
                                  color: selectedIcons[i].value
                                      ? const Color.fromARGB(255, 89, 217, 153)
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  selectedIcons[i].value =
                                      !selectedIcons[i].value;
                                  _calculateTotals();
                                },
                              ),
                            ],
                          ),

                          // Botones de items
                          Wrap(
                            spacing: 8.0,
                            children: items.asMap().entries.map((itemEntry) {
                              final itemIndex = itemEntry.key;
                              final itemText = itemEntry.value;

                              return ElevatedButton(
                                onPressed: () {
                                  final currentVal =
                                      selectedButtons[i][itemIndex].value;
                                  selectedButtons[i][itemIndex].value =
                                      !currentVal;
                                  _calculateTotals();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedButtons[i][itemIndex]
                                          .value
                                      ? const Color.fromARGB(255, 89, 217, 153)
                                      : const Color.fromARGB(
                                          255, 238, 238, 238),
                                ),
                                child: Text(itemText),
                              );
                            }).toList(),
                          ),

                          // Kg y monedas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(ctx).size.width * 0.3,
                                child: TextField(
                                  controller: kgControllers[i],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Kg Aprox.",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Monedas a Recibir",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    unitValues[i].value.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Divider(),
                        ],
                      );
                    });
                  }).toList(),

                  // Totales
                  const Divider(),
                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTotalRow("Total Kg",
                            "${totalKg.value.toStringAsFixed(2)} Kg"),
                        _buildTotalRow("Total Monedas",
                            "${totalMonedas.value.toStringAsFixed(2)}"),
                        _buildTotalRow(
                            "En bolsas individuales", "${totalBolsas.value}"),
                        _buildTotalRow("Segregados correctamente",
                            "${segregadosCorrectamente.value}"),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      // Ejemplo: Marcamos isRecycled=true
                      // O actualizamos "residues" con los nuevos valores, etc.
                      await Get.find<HomecollectorController>()
                          .markAsRecycled(waste);

                      Get.snackbar(
                        "Recolección Solicitada",
                        "Se actualizó isRecycled = true.",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(63, 188, 159, 1),
                    ),
                    child: const Text("Confirmar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
