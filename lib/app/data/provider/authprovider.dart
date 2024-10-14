import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Iniciar sesión con correo y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      // Inicia sesión con Firebase Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Obtenemos el UID del usuario autenticado
        String uid = user.uid;

        // Buscamos el usuario en Firestore por su UID
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          print('Usuario encontrado en Firestore.');
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
      // Crear nuevo usuario con Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Obtenemos el UID del usuario autenticado
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
      // Envía un correo electrónico para restablecer la contraseña
      await _auth.sendPasswordResetEmail(email: email);
      print('Correo de restablecimiento de contraseña enviado a $email.');
    } catch (e) {
      print("Error al enviar correo de restablecimiento de contraseña: $e");
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}
