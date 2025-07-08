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
              userName = ('${userData['name'] ?? ''} ${userData['lastname'] ?? ''}').trim();
              userAddress = userData['address'] ?? '';
            }
          }
        }

        if (userAddress.isEmpty) {
          userAddress = data['userAddress'] ?? data['address'] ?? '';
        }

        return RedeemedIncentiveModel(
          id: doc.id,
          docRef: doc.reference,
          incentiveId: data['incentiveId'],
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: RedeemedIncentiveModel.toDouble(data['price']),
          redeemedCoins: RedeemedIncentiveModel.toDouble(data['redeemedCoins']),
          status: data['status'] ?? 'pendiente',
          image: data['image'] ?? '',
          createdAt: data['createdAt'] is Timestamp ? data['createdAt'] : null,
          userName: userName,
          userAddress: userAddress,
        );
      }).toList());

      // Ordenar la lista: 'pendiente' primero, luego por fecha descendente
      incentives.sort((a, b) {
        if (a.status == 'pendiente' && b.status != 'pendiente') {
          return -1; // a viene antes que b
        }
        if (a.status != 'pendiente' && b.status == 'pendiente') {
          return 1; // b viene antes que a
        }
        // Si ambos tienen el mismo estado o ninguno es 'pendiente', ordenar por fecha
        if (a.createdAt != null && b.createdAt != null) {
          return b.createdAt!.compareTo(a.createdAt!); // Descendente
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
