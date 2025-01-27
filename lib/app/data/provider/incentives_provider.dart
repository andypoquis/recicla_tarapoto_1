// lib/app/providers/incentives_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/data/models/incentive.dart';

class IncentivesProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retorna un `Stream` que emite listas de [Incentive] cada vez que hay
  /// un cambio en la colección 'incentives'.
  Stream<List<Incentive>> getIncentives() {
    return _firestore.collection('incentives').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Incentive.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  /// Agrega un nuevo incentivo a la colección 'incentives'.
  Future<DocumentReference> addIncentive(Incentive incentive) async {
    try {
      return await _firestore
          .collection('incentives')
          .add(incentive.toFirestore());
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar el incentivo',
        backgroundColor: Colors.redAccent,
      );
      rethrow;
    }
  }

  /// Actualiza un incentivo existente en la colección 'incentives'.
  Future<void> updateIncentive(String docId, Incentive incentive) async {
    try {
      await _firestore
          .collection('incentives')
          .doc(docId)
          .update(incentive.toFirestore());

      Get.snackbar(
        'Éxito',
        'El incentivo ha sido actualizado correctamente.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el incentivo',
        backgroundColor: Colors.redAccent,
      );
      rethrow;
    }
  }

  /// Elimina (físicamente) un incentivo de la colección 'incentives'.
  Future<void> deleteIncentive(String docId) async {
    try {
      await _firestore.collection('incentives').doc(docId).delete();
      Get.snackbar(
        'Completo',
        'El incentivo ha sido eliminado correctamente',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar el incentivo',
        backgroundColor: Colors.redAccent,
      );
      rethrow;
    }
  }

  /// Obtiene un incentivo por su ID de documento.
  Future<Incentive?> getIncentiveById(String incentiveId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('incentives').doc(incentiveId).get();
      if (doc.exists) {
        return Incentive.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error al obtener el incentivo: $e');
      return null;
    }
  }
}
