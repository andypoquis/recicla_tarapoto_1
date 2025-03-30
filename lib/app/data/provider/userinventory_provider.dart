// lib/app/providers/userinventory_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/usermodel.dart';

class UserInventoryProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retorna un `Stream` que emite listas de [UserModel] cada vez que hay
  /// un cambio en la colección 'users' cuyo `iscollector` es `false`.
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection('users')
        .where('iscollector',
            isEqualTo: false) // Filtramos por iscollector = false
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Agrega un nuevo usuario a la colección 'users'.
  Future<DocumentReference> addUser(UserModel user) async {
    try {
      return await _firestore.collection('users').add(user.toFirestore());
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agregar el usuario',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  /// Actualiza un usuario existente en la colección 'users'.
  Future<void> updateUser(String docId, UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(docId)
          .update(user.toFirestore());

      Get.snackbar(
        'Éxito',
        'El usuario ha sido actualizado correctamente.',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el usuario',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  /// Elimina (físicamente) un usuario de la colección 'users'.
  Future<void> deleteUser(String docId) async {
    try {
      await _firestore.collection('users').doc(docId).delete();
      Get.snackbar(
        'Completo',
        'El usuario ha sido eliminado correctamente',
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar el usuario',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  /// Obtiene un usuario por su ID de documento.
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error al obtener el usuario: $e');
      return null;
    }
  }
}
