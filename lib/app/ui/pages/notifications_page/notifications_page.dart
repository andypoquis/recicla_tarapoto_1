import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/notifications_controller.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Enviar Comunicado
            Text(
              'Enviar Comunicado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => TextField(
                        controller: controller.titleController.value,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Obx(() => TextField(
                        controller: controller.contentController.value,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Obx(() => Center(
                        child: controller.isSendingAnnouncement.value
                            ? const CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: controller
                                        .isSendingAnnouncement.value
                                    ? null
                                    : () =>
                                        controller.sendAnnouncement(context),
                                icon: Icon(Icons.send),
                                label: Text('Send'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sección: Subir Contenido al Carrusel
            Text(
              'Subir Contenido al Carrusel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Motivo:',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: Text('participacion'),
                            selected:
                                controller.reason.value == 'participacion',
                            onSelected: (selected) {
                              controller
                                  .setReason(selected ? 'participacion' : '');
                            },
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: Text('premio'),
                            selected: controller.reason.value == 'premio',
                            onSelected: (selected) {
                              controller.setReason(selected ? 'premio' : '');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subir Foto:',
                            style: TextStyle(fontSize: 16),
                          ),
                          ElevatedButton.icon(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.pickImage(),
                            icon: Icon(Icons.folder_open),
                            label: Text('Seleccionar archivo'),
                          ),
                        ],
                      ),
                      if (controller.selectedImage.value != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.file(
                            controller.selectedImage.value!,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (controller.isLoading.value)
                        const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.uploadCarouselImage(context),
                          icon: Icon(Icons.send),
                          label: Text('Enviar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Campo de texto
  Widget _buildTextField({required String label, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Tarjeta
  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  // Chip de selección con estado
  // (Ya no se usa, la selección se maneja con GetX)
}
