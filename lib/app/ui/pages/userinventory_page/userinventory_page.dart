import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/userinventory_controller.dart';

class UserinventoryPage extends GetView<UserinventoryController> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> users = [
      {
        'name': 'Roy Franco Ruíz García',
        'dni': '73188669',
        'phone': '971245354',
        'address': 'Jr. Alerta #247',
        'type': 'Casa',
      },
      // Agrega más usuarios aquí si es necesario
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventario de Usuarios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildListItem(user, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, String> user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () => _showUserDetailsDialog(context, user),
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(63, 188, 159, 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            user['address'] ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                user['name'] ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildDetailRow('DNI:', user['dni'] ?? ''),
              _buildDetailRow('Teléfono:', user['phone'] ?? ''),
              _buildDetailRow('Calle:', user['address'] ?? ''),
              _buildDetailRow('Tipo:', user['type'] ?? ''),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
