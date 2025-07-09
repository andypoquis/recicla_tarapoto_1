// lib/app/ui/pages/homecollector/homecollector_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/homecollector_controller.dart';
import '../../../data/models/waste_collection.dart';
import '../../../data/models/residue_item.dart';

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

  // Método auxiliar para mostrar filas de detalle en el diálogo
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Abre el diálogo y llena automáticamente los campos
  void _showFloatingDialog(BuildContext context, WasteCollectionModel waste) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
  
    // Fecha formateada
    final dateFormatted = waste.date != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(waste.date!)
        : 'Fecha no disponible';

    // Controladores para edición
    final kgControllers = <TextEditingController>[];
    final coinsControllers = <TextEditingController>[];
    final segregationControllers = <bool>[];
    
    // Variables reactivas para los totales
    final totalKg = waste.totalKg.obs;
    final totalCoins = waste.totalCoins.obs;
    final correctlySegregated = waste.correctlySegregated.obs;
  
    // Preparar controladores para cada residuo
    for (var residue in waste.residues) {
      kgControllers.add(TextEditingController(text: residue.approxKg.toString()));
      // Manejo de coinsPerType con valor predeterminado si es necesario
      final coinsText = residue.coinsPerType.isEmpty ? "0" : residue.coinsPerType;
      coinsControllers.add(TextEditingController(text: coinsText));
      // Añadir el valor de individualBag
      segregationControllers.add(residue.individualBag);
    }
    
    // Función para recalcular totales
    void _calculateTotals() {
      double newTotalKg = 0.0;
      double newTotalCoins = 0.0;
      int newCorrectlySegregated = 0;
      
      for (int i = 0; i < waste.residues.length; i++) {
        // Sumar kg
        final kg = double.tryParse(kgControllers[i].text) ?? 0.0;
        newTotalKg += kg;
        
        // Monedas base: 3 monedas por cada kg
        final kgCoins = kg * 3.0;
        coinsControllers[i].text = kgCoins.toStringAsFixed(2);
        
        // Contar segregados correctamente y agregar 5 monedas extra por cada uno
        if (segregationControllers[i]) {
          newCorrectlySegregated += 1;
        }
      }
      
      // Calcular total de monedas: 3 por cada kg + 5 por cada segregación correcta
      newTotalCoins = (newTotalKg * 3.0) + (newCorrectlySegregated * 5.0);
      
      // Actualizar valores reactivos
      totalKg.value = newTotalKg;
      totalCoins.value = newTotalCoins;
      correctlySegregated.value = newCorrectlySegregated;
    }
    
    // Agregar listeners a los controladores para recalcular totales
    for (var controller in kgControllers) {
      controller.addListener(_calculateTotals);
    }
    for (var controller in coinsControllers) {
      controller.addListener(_calculateTotals);
    }
    
    // Calcular totales iniciales
    _calculateTotals();

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
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF31ADA0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Detalles de Recolección",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información general
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Información General",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF31ADA0),
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildDetailRow("Dirección:", waste.address),
                                _buildDetailRow("Fecha:", dateFormatted),
                                _buildDetailRow(
                                  "Estado:",
                                  waste.isRecycled ? "Reciclado" : "Pendiente",
                                  valueColor: waste.isRecycled
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Detalles de residuos
                        Text(
                          "Detalle de Residuos",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF31ADA0),
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        if (waste.residues.isEmpty)
                          Center(
                            child: Text("No hay residuos registrados."),
                          )
                        else
                          ...List.generate(waste.residues.length, (index) {
                            final residue = waste.residues[index];
                            // Obtener ítems seleccionados
                            String itemsText;
                            if (residue.selectedItems.isEmpty) {
                                itemsText = "Ninguno";
                            } else {
                                itemsText = residue.selectedItems.join(", ");
                            }
                                
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Color(0xFF59D999),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      residue.type.isEmpty ? "Tipo no especificado" : residue.type,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF31ADA0),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    _buildDetailRow("Ítems:", itemsText),
                                    
                                    // Campo editable para Kg
                                    Row(
                                      children: [
                                        Text("Cantidad (Kg):", 
                                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            controller: kgControllers[index],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    
                                    // Campo editable para monedas
                                    Row(
                                      children: [
                                        Text("Monedas:", 
                                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            controller: coinsControllers[index],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    
                                    // Toggle para segregación correcta
                                    Row(
                                      children: [
                                        Text("Segregación correcta:", 
                                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                        ),
                                        SizedBox(width: 10),
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return Switch(
                                              value: segregationControllers[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  segregationControllers[index] = value;
                                                });
                                                // Recalcular totales cuando cambie el switch
                                                _calculateTotals();
                                              },
                                              activeColor: Color(0xFF59D999),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                        SizedBox(height: 16),

                        // Totales
                        Card(
                          color: Color(0xFFF4F6F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Totales",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF31ADA0),
                                  ),
                                ),
                                SizedBox(height: 8),
                                
                                // Total Kg (reactivo)
                                Row(
                                  children: [
                                    Text("Total Kg:", 
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Obx(() => TextField(
                                        controller: TextEditingController(text: totalKg.value.toStringAsFixed(2)),
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                
                                // Total Monedas (reactivo)
                                Row(
                                  children: [
                                    Text("Total Monedas:", 
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Obx(() => TextField(
                                        controller: TextEditingController(text: totalCoins.value.toStringAsFixed(2)),
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                
                                // Correctamente segregados (reactivo)
                                Row(
                                  children: [
                                    Text("Segregados correctamente:", 
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Obx(() => TextField(
                                        controller: TextEditingController(text: correctlySegregated.value.toString()),
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                        ),
                                      )),
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
                ),

                // Botones de acción
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!waste.isRecycled)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Preparar actualizaciones
                              List<ResidueItem> updatedResidues = [];
                              for (int i = 0; i < waste.residues.length; i++) {
                                final residue = waste.residues[i];
                                updatedResidues.add(ResidueItem(
                                  type: residue.type,
                                  approxKg: double.tryParse(kgControllers[i].text) ?? residue.approxKg,
                                  coinsPerType: coinsControllers[i].text,
                                  individualBag: segregationControllers[i],
                                  selectedItems: residue.selectedItems,
                                ));
                              }
                              
                              // Crear modelo actualizado con valores reactivos
                              final updatedWaste = WasteCollectionModel(
                                id: waste.id,
                                address: waste.address,
                                isRecycled: true,
                                totalBags: waste.totalBags,
                                totalCoins: totalCoins.value,
                                totalKg: totalKg.value,
                                correctlySegregated: correctlySegregated.value,
                                residues: updatedResidues,
                                userReference: waste.userReference,
                                date: waste.date,
                              );
                              
                              Navigator.of(ctx).pop();
                              await controller.markAsRecycled(updatedWaste);
                              Get.snackbar(
                                "Recolección completada",
                                "La recolección ha sido marcada como reciclada",
                                backgroundColor: Colors.green.withOpacity(0.7),
                                colorText: Colors.white,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF59D999),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              "Guardar y Marcar como Reciclado",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      if (waste.isRecycled) 
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Cerrar"),
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
