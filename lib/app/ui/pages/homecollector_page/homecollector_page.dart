import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/homecollector_controller.dart';

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
                child: ListView(
                  children: [
                    _buildListItem('Jr. Alerta #247', context),
                    _buildListItem('Jr. Perú #347', context),
                    _buildListItem('Jr. Manuela Morey #584', context),
                    _buildListItem('Jr. Manuela Morey #658', context),
                    _buildListItem('Jr. Pedro #458', context),
                    _buildListItem('Jr. Alerta #247', context),
                    _buildListItem('Jr. Perú #347', context),
                    _buildListItem('Jr. Manuela Morey #584', context),
                    _buildListItem('Jr. Manuela Morey #658', context),
                    _buildListItem('Jr. Pedro #458', context),
                    _buildListItem('Jr. Alerta #247', context),
                    _buildListItem('Jr. Perú #347', context),
                    _buildListItem('Jr. Manuela Morey #584', context),
                    _buildListItem('Jr. Manuela Morey #658', context),
                    _buildListItem('Jr. Pedro #458', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          _showFloatingDialog(
              context, text); // Pasar el texto del ítem seleccionado
        },
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 89, 217, 206),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _showFloatingDialog(BuildContext context, String text) {
    // Datos para el diálogo flotante
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
            List.filled((residuos[index]["items"] as List).length, false).obs);
    final isKgFieldEnabled = List.filled(residuos.length, false).obs;

    for (var _ in residuos) {
      kgControllers.add(TextEditingController());
      unitValues.add(0.0.obs);
    }

    // Función para calcular los totales
    void _calculateTotals() {
      totalKg.value = 0.0;
      totalMonedas.value = 0.0;
      totalBolsas.value = 0;
      segregadosCorrectamente.value = 0;

      for (var i = 0; i < residuos.length; i++) {
        if (isKgFieldEnabled[i]) {
          final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
          unitValues[i].value = kg * 3; // Calcula el monto automático
          totalKg.value += kg;
          totalMonedas.value += unitValues[i].value;

          if (selectedIcons[i]) {
            segregadosCorrectamente.value += 1;
          }
        }
      }
      totalBolsas.value = isKgFieldEnabled.where((enabled) => enabled).length;
    }

    for (var controller in kgControllers) {
      controller.addListener(_calculateTotals);
    }

    // Mostrar el diálogo flotante
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Recolección Seleccionada: $text",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center, // Esto centra el texto
                  ),
                  SizedBox(height: 10),
                  Text("Tipo de Residuo",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                            Text(res["tipo"] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Obx(() => IconButton(
                                  icon: Icon(
                                    Icons.shopping_bag,
                                    color: selectedIcons[index]
                                        ? const Color.fromARGB(
                                            255, 89, 217, 153)
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Lógica para seleccionar/desmarcar el ícono
                                    selectedIcons[index] =
                                        !selectedIcons[index];
                                    _calculateTotals();
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
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Obx(() => TextField(
                                    controller: kgControllers[index],
                                    keyboardType: TextInputType.number,
                                    enabled: isKgFieldEnabled[index],
                                    decoration: InputDecoration(
                                        labelText: "Kg Aprox.",
                                        border: OutlineInputBorder()),
                                  )),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Monedas a Recibir",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                Obx(() => Center(
                                    child: Text(
                                        "${unitValues[index].value.toStringAsFixed(2)}",
                                        style: TextStyle(fontSize: 20)))),
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
                          "Gracias por su colaboración.");
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
}
