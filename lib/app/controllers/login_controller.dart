import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Alias para tu propio AuthProvider
import '../data/provider/authprovider.dart' as custom_auth;

class LoginController extends GetxController {
  // Define las propiedades reactivas para email y password
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs; // Para manejar el estado de carga

  // Instancia de tu AuthProvider (el que guardas en Firestore/GetStorage)
  final custom_auth.AuthProvider _authProvider = custom_auth.AuthProvider();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Método para manejar la lógica de inicio de sesión
  Future<void> login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Inicia el estado de carga
        isLoading.value = true;

        // Llama a signInWithEmail del AuthProvider de tu proyecto
        firebase_auth.User? user =
            await _authProvider.signInWithEmail(email.value, password.value);

        // Verificamos si el user no es null => Login exitoso
        if (user != null) {
          // El usuario ha iniciado sesión correctamente
          Get.snackbar('Login exitoso', 'Bienvenido de nuevo');
          // Aquí puedes redirigir a la pantalla de inicio (Home)
          Get.offNamed('/home');
        } else {
          // Si user es null, mostramos error
          Get.snackbar('Error', 'Credenciales incorrectas. Intenta de nuevo.');
        }
      } catch (e) {
        // Manejo de errores durante el login
        Get.snackbar('Error', 'Ocurrió un error: $e');
        print("Error de inicio de sesión: $e");
      } finally {
        // Detiene el estado de carga
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Error', 'Por favor, complete todos los campos.');
    }
  }
}
