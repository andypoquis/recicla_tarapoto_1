import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
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
                children: [
                  _buildTextField(label: 'Título'),
                  const SizedBox(height: 10),
                  _buildTextField(label: 'Contenido', maxLines: 4),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sección: Subir Contenido de Usuario
            Text(
              'Subir Contenido de Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCard(
              child: Column(
                children: [
                  _buildTextField(label: 'DNI Usuario'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Motivo:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      _buildChip(label: 'Incentivo'),
                      const SizedBox(width: 10),
                      _buildChip(label: 'Participación'),
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
                        onPressed: () {
                          // Acción para subir archivo
                        },
                        icon: Icon(Icons.folder_open),
                        label: Text('Seleccionar archivo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir un campo de texto
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

  // Widget para construir una tarjeta
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

  // Widget para construir un chip
  Widget _buildChip({required String label}) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (bool selected) {
        // Acción para manejar selección del chip
      },
    );
  }
}
