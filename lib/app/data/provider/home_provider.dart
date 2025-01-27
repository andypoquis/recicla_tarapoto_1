// lib/app/providers/home_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/carousel_image.dart';

class HomeProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retorna un `Stream` que emite listas de [CarouselImage] cada vez que hay
  /// un cambio en la colección 'carousel_image'.
  Stream<List<CarouselImage>> getCarouselImages() {
    return _firestore.collection('carousel_image').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CarouselImage.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  /// Agrega una nueva imagen al carrusel (opcional, si necesitas esta funcionalidad).
  Future<DocumentReference> addCarouselImage(
      CarouselImage carouselImage) async {
    try {
      return await _firestore
          .collection('carousel_image')
          .add(carouselImage.toFirestore());
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar la imagen al carrusel',
        backgroundColor: Colors.redAccent,
      );
      rethrow;
    }
  }

  /// Actualiza una imagen del carrusel (opcional).
  Future<void> updateCarouselImage(
      String docId, CarouselImage carouselImage) async {
    try {
      await _firestore
          .collection('carousel_image')
          .doc(docId)
          .update(carouselImage.toFirestore());

      Get.snackbar(
        'Éxito',
        'La imagen del carrusel ha sido actualizada correctamente.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la imagen del carrusel',
        backgroundColor: Colors.redAccent,
      );
      rethrow;
    }
  }

  /// Elimina una imagen del carrusel (opcional).
  Future<void> deleteCarouselImage(String docId) async {
    try {
      await _firestore.collection('carousel_image').doc(docId).delete();
      Get.snackbar(
        'Completo',
        'La imagen ha sido eliminada correctamente',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar la imagen',
        backgroundColor: Colors.redAccent,
      );
      rethrow;
    }
  }
}
