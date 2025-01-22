// lib/app/providers/auth_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../models/usermodel.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instancia del storage (usa el mismo nombre que inicializaste en main: 'GlobalStorage')
  final GetStorage _box = GetStorage('GlobalStorage');

  // Iniciar sesión con correo y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print('Usuario logged');
      if (user != null) {
        // Obtenemos el UID del usuario autenticado
        String uid = user.uid;

        // Buscamos el usuario en Firestore por su UID
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          // Convertimos el documento a nuestro modelo UserModel
          final userModel = UserModel.fromFirestore(
            userDoc.data() as Map<String, dynamic>,
          );

          // Guardamos en GetStorage:
          //   1) loggedIn = true
          //   2) userData en formato Map, para luego recuperarlo
          print('El usuario es recolector: ${userModel.iscollector}');
          _box.write('loggedIn', true);
          _box.write('iscollector', userModel.iscollector);

          _box.write('userData', userModel.toFirestore());

          print('Usuario encontrado y almacenado localmente.');
        } else {
          print('Usuario no encontrado en Firestore.');
        }
      }
      return user;
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }

  // Registrar un nuevo usuario con correo y contraseña
  Future<User?> registerWithEmail(
      String email, String password, Map<String, dynamic> userData) async {
    try {
      // Crear nuevo usuario en Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        String uid = user.uid;

        // Guardar la información del usuario en Firestore
        await _firestore.collection('users').doc(uid).set({
          'address': userData['address'] ?? '',
          'dni': userData['dni'] ?? '',
          'lastname': userData['lastname'] ?? '',
          'name': userData['name'] ?? '',
          'phone_number': userData['phone_number'] ?? '',
          'type_user': userData['type_user'] ?? [],
          'uid': uid,
        });

        print('Usuario registrado en Firestore.');

        // Obtenemos el documento recién guardado para almacenarlo localmente
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          final userModel = UserModel.fromFirestore(
            userDoc.data() as Map<String, dynamic>,
          );

          // Guardamos en GetStorage
          _box.write('loggedIn', true);
          _box.write('userData', userModel.toFirestore());
        }
      }

      return user;
    } catch (e) {
      print("Error al registrar: $e");
      return null;
    }
  }

  // Restablecer contraseña
  Future<void> changePassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Correo de restablecimiento de contraseña enviado a $email.');
    } catch (e) {
      print("Error al enviar correo de restablecimiento de contraseña: $e");
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // Al cerrar sesión, limpiamos el Storage
      _box.write('loggedIn', false);
      _box.remove('userData'); // o .erase() si quieres limpiar todo

      print("Sesión cerrada y Storage limpiado.");
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}
