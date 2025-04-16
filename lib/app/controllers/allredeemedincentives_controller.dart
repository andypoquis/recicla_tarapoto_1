import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/data/models/redeemed_incentive_model.dart';

class AllRedeemedIncentivesController extends GetxController {
  /// Stream con todos los canjes de la subcolección 'redeemedIncentives'
  Stream<List<RedeemedIncentiveModel>> get allRedeemedIncentivesStream {
    return FirebaseFirestore.instance
        .collectionGroup('redeemedIncentives')
        .snapshots()
        .map((query) => query.docs
            .map((doc) => RedeemedIncentiveModel.fromFirestore(doc))
            .toList());
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
