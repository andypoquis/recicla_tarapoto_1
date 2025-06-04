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
      return Future.wait(query.docs.map((doc) async {
        final data = doc.data();
        String userName = '';
        String userAddress = '';
        // Asumimos que doc.reference.parent.parent ES la referencia al documento del usuario.
        final userDocRef = doc.reference.parent
            .parent; // Esta es la DocumentReference al usuario.

        if (userDocRef == null) {
          print(
              '[DEBUG Controller] No se pudo obtener la referencia al documento de USUARIO (padre del padre) para el canje: ${doc.id}. Ruta del canje: ${doc.reference.path}');
        } else {
          print(
              '[DEBUG Controller] Intentando obtener datos del USUARIO desde: ${userDocRef.path} para el canje: ${doc.id}');
          final userSnap = await userDocRef.get();
          if (!userSnap.exists) {
            print(
                '[DEBUG Controller] El documento de USUARIO no existe en: ${userDocRef.path} (para canje ${doc.id})');
          } else {
            final userData = userSnap.data() as Map<String, dynamic>?;
            if (userData == null) {
              print(
                  '[DEBUG Controller] Los datos del documento de USUARIO son null en: ${userDocRef.path} (para canje ${doc.id})');
            } else {
              // Los campos 'name' y 'lastname' vienen del documento del usuario.
              userName = ((userData['name'] ?? '') +
                      ' ' +
                      (userData['lastname'] ?? ''))
                  .trim();
              userAddress = userData['address'] ??
                  ''; // El campo 'address' viene del documento del usuario.
              print(
                  '[DEBUG Controller] DATOS DEL USUARIO OBTENIDOS - userName: $userName | userAddress: $userAddress | Desde Usuario Ref: ${userDocRef.path} (para canje ${doc.id})');
              if (userName.isEmpty)
                print(
                    '[DEBUG Controller] Alerta: userName vacío en USUARIO ${userDocRef.path}');
              if (userAddress.isEmpty)
                print(
                    '[DEBUG Controller] Alerta: userAddress vacío en USUARIO ${userDocRef.path}');
            }
          }
        }

        // Fallbacks
        if (userAddress.isEmpty && data['userAddress'] != null) {
          userAddress = data['userAddress'];
          print(
              '[DEBUG Controller] userAddress tomado del canje: $userAddress');
        }
        if (userAddress.isEmpty && data['address'] != null) {
          userAddress = data['address'];
          print(
              '[DEBUG Controller] userAddress tomado del wasteCollection: $userAddress');
        }
        // Si no hay address en el user, usar el del canje
        if (userAddress.isEmpty && data['userAddress'] != null) {
          userAddress = data['userAddress'];
        }
        // Si no hay address en user ni en canje, usar el address de wasteCollection si existe
        if (userAddress.isEmpty && data['address'] != null) {
          userAddress = data['address'];
        }
        // Construir el modelo combinando datos
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
          createdAt: data['createdAt'] is Timestamp
              ? data['createdAt'] as Timestamp
              : null,
          userName: userName,
          userAddress: userAddress,
        );
      }).toList());
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
