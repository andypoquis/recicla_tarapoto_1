// lib/app/ui/pages/all_redeemed_incentives_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/incentives_controller.dart';
import '../../../data/models/redeemedIncentiveWithUser.dart';
import '../../../data/models/redeemed_incentive_model.dart';

class AllRedeemedIncentivesPage
    extends GetView<AllRedeemedIncentivesController> {
  const AllRedeemedIncentivesPage({Key? key}) : super(key: key);

  static const colorPrimaryDark = Color(0xFF31ADA0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incentivos Canjeados'),
        backgroundColor: colorPrimaryDark,
      ),
      body: StreamBuilder<List<RedeemedIncentiveWithUser>>(
        stream: controller.allRedeemedIncentivesStream,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Sin datos
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(child: Text('No hay canjes registrados.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _buildItem(
                  context, item.incentive, item.userName, item.userAddress);
            },
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, RedeemedIncentiveModel incentive,
      String userName, String userAddress) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usuario
            Row(
              children: [
                const Icon(Icons.person, color: colorPrimaryDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userName.isNotEmpty ? userName : 'Sin nombre',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Dirección
            if (userAddress.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 18, color: colorPrimaryDark),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      userAddress,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],

            const Divider(height: 16),
            // Nombre incentivo
            Row(
              children: [
                const Icon(Icons.card_giftcard, color: colorPrimaryDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    incentive.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            // Descripción
            if (incentive.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                incentive.description,
                style: const TextStyle(color: Colors.grey),
              ),
            ],

            const SizedBox(height: 8),
            // Estado + Botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estado: ${incentive.status}',
                  style: TextStyle(
                    color: (incentive.status == 'pendiente')
                        ? Colors.amber[800]
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (incentive.status == 'pendiente')
                  TextButton(
                    onPressed: () {
                      controller.markAsCompleted(incentive);
                    },
                    child: const Text('Completar'),
                  )
                else
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
