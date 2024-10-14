import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Define las propiedades reactivas para email y password
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs; // Para manejar el estado de carga

  // Instancia de FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para manejar la lógica de inicio de sesión
  Future<void> login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Inicia el estado de carga
        isLoading.value = true;

        // Lógica de autenticación con Firebase Auth
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );

        // Usuario autenticado correctamente
        User? user = userCredential.user;
        if (user != null) {
          // El usuario ha iniciado sesión correctamente
          Get.snackbar('Login exitoso', 'Bienvenido de nuevo');
          // Aquí puedes redirigir a la pantalla de inicio o dashboard
          Get.toNamed('/home');
        }
      } catch (e) {
        // Manejo de errores durante el login
        Get.snackbar('Error', 'Credenciales incorrectas. Intenta de nuevo.');
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
