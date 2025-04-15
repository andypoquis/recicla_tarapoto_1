// lib/app/controllers/all_redeemed_incentives_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/models/redeemedIncentiveWithUser.dart';
import '../data/models/redeemed_incentive_model.dart';

class AllRedeemedIncentivesController extends GetxController {
  /// Stream con todos los canjes de la subcolección 'redeemedIncentives'
  /// de todos los usuarios. Además, se consulta el doc del usuario padre
  /// para extraer su `name` y `address`.
  Stream<List<RedeemedIncentiveWithUser>> get allRedeemedIncentivesStream {
    // Obtenemos un stream de todos los docs en la subcolección.
    final queryStream = FirebaseFirestore.instance
        .collectionGroup('redeemedIncentives')
        .snapshots();

    // Convertimos cada snapshot en objetos RedeemedIncentiveWithUser
    return queryStream.asyncMap((querySnapshot) async {
      final List<RedeemedIncentiveWithUser> result = [];

      // Recorremos cada documento de canje
      for (final docSnap in querySnapshot.docs) {
        final redeemedIncentive = RedeemedIncentiveModel.fromFirestore(docSnap);

        // Obtenemos la referencia al doc del usuario => parent.parent
        final userDocRef = docSnap.reference.parent.parent;
        if (userDocRef == null) {
          // Si por alguna razón no existe, lo ignoramos o asumimos valores vacíos
          continue;
        }

        // Leemos el doc del usuario para obtener nombre, address, etc.
        final userDocSnap = await userDocRef.get();
        final userData = userDocSnap.data() as Map<String, dynamic>?;

        final userName = userData?['name'] ?? '';
        final userAddress = userData?['address'] ?? '';

        // Combinamos
        result.add(
          RedeemedIncentiveWithUser(
            incentive: redeemedIncentive,
            userName: userName,
            userAddress: userAddress,
          ),
        );
      }

      return result;
    });
  }

  /// Cambia el estado de pendiente a completado
  Future<void> markAsCompleted(RedeemedIncentiveModel incentive) async {
    try {
      await incentive.docRef.update({'status': 'completado'});
    } catch (e) {
      print('Error actualizando estado: $e');
      rethrow;
    }
  }
}
