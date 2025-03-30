import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/waste_collection.dart';

class WasteCollectionsProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retorna un Stream de [WasteCollectionModel] donde isRecycled = false
  Stream<List<WasteCollectionModel>> getPendingWasteCollections() {
    return _firestore
        .collection('wasteCollections')
        .where('isRecycled', isEqualTo: false)
        .snapshots()
        .map((qs) => qs.docs
            .map((doc) => WasteCollectionModel.fromFirestore(doc))
            .toList());
  }

  /// Actualiza un documento de la colección a partir de su ID
  Future<void> updateWasteCollection(
      String docId, WasteCollectionModel updatedModel) async {
    try {
      await _firestore
          .collection('wasteCollections')
          .doc(docId)
          .update(updatedModel.toFirestore());
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la recolección');
      rethrow;
    }
  }

  /// Agrega una nueva recolección
  Future<DocumentReference> addWasteCollection(
      WasteCollectionModel wasteCollection) async {
    try {
      return await _firestore
          .collection('wasteCollections')
          .add(wasteCollection.toFirestore());
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar la recolección',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  /// Elimina físicamente una recolección
  Future<void> deleteWasteCollection(String docId) async {
    try {
      await _firestore.collection('wasteCollections').doc(docId).delete();
      Get.snackbar(
        'Completo',
        'La recolección ha sido eliminada correctamente',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar la recolección',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  /// Obtiene una recolección por ID
  Future<WasteCollectionModel?> getWasteCollectionById(String docId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('wasteCollections').doc(docId).get();
      if (doc.exists) {
        return WasteCollectionModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error al obtener la recolección: $e');
      return null;
    }
  }
}
