import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/data/models/redeemed_incentive_model.dart';

class AllRedeemedIncentivesController extends GetxController {
  /// Stream con todos los canjes de la subcolección 'redeemedIncentives'
  Stream<List<RedeemedIncentiveModel>> get allRedeemedIncentivesStream {
    return FirebaseFirestore.instance
        .collectionGroup('redeemedIncentives')
        .snapshots()
        .asyncMap((query) async {
      final incentives = await Future.wait(query.docs.map((doc) async {
        final data = doc.data();
        String userName = '';
        String userAddress = '';

        final userDocRef = doc.reference.parent.parent;
        if (userDocRef != null) {
          final userSnap = await userDocRef.get();
          if (userSnap.exists) {
            final userData = userSnap.data() as Map<String, dynamic>?;
            if (userData != null) {
              userName =
                  ('${userData['name'] ?? ''} ${userData['lastname'] ?? ''}')
                      .trim();
              userAddress = userData['address'] ?? '';
            }
          }
        }

        // Fallback si no vino en el doc del usuario
        if (userAddress.isEmpty) {
          userAddress = data['userAddress'] ?? data['address'] ?? '';
        }

        // Usamos la factory (ya maneja qty, refs, etc.)
        final base = RedeemedIncentiveModel.fromFirestore(doc);

        // Devolvemos el modelo enriquecido con nombre/dirección (manteniendo el resto)
        return RedeemedIncentiveModel(
          id: base.id,
          docRef: base.docRef,
          incentiveId: base.incentiveId,
          name: base.name,
          description: base.description,
          price: base.price,
          qty: base.qty,
          redeemedCoins: base.redeemedCoins,
          status: base.status,
          image: base.image,
          createdAt: base.createdAt,
          userName: userName.isNotEmpty ? userName : base.userName,
          userAddress: userAddress.isNotEmpty ? userAddress : base.userAddress,
          incentiveRef: base.incentiveRef,
          userRef: base.userRef,
          idempotencyKey: base.idempotencyKey,
        );
      }).toList());

      // Ordenar: 'pendiente' primero, luego por fecha desc
      incentives.sort((a, b) {
        if (a.status == 'pendiente' && b.status != 'pendiente') return -1;
        if (a.status != 'pendiente' && b.status == 'pendiente') return 1;
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!);
        }
        return 0;
      });

      return incentives;
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
