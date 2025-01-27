import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/data/provider/authprovider.dart';

class RegisterController extends GetxController {
  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController =
      TextEditingController(); // Nuevo controlador para el email
  var dniController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();
  var userType = 'Casa'.obs; // Variable reactiva para el tipo de usuario

  var isLoading = false.obs; // Variable para manejar el loading

  final AuthProvider _authProvider =
      AuthProvider(); // Instancia de AuthProvider

  // Lógica para registrar el usuario
  Future<void> registerUser() async {
    String name = nameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text; // Obtener el correo electrónico
    String dni = dniController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String password = passwordController.text;
    String selectedUserType = userType.value;

    // Validaciones básicas
    if (name.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty || // Validar que el email no esté vacío
        dni.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Error', 'Por favor, completa todos los campos.');
      return;
    }

    // Mostrar el loading
    isLoading.value = true;

    // Datos del usuario a registrar
    Map<String, dynamic> userData = {
      'name': name,
      'lastname': lastName,
      'email': email, // Agregar el correo al mapa de datos
      'dni': dni,
      'phone_number': phone,
      'address': address,
      'type_user': [selectedUserType], // Puedes agregar más tipos si lo deseas
    };

    try {
      // Registrar el usuario en Firebase Authentication y guardar en Firestore
      var user =
          await _authProvider.registerWithEmail(email, password, userData);
      if (user != null) {
        Get.snackbar('Registro exitoso', 'Usuario registrado correctamente');
        // Redirigir o hacer otras acciones
      } else {
        Get.snackbar('Error', 'No se pudo registrar el usuario');
      }
    } catch (e) {
      Get.snackbar('Error', 'Hubo un problema al registrar el usuario');
      print('Error en el registro: $e');
    } finally {
      // Ocultar el loading
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Liberar los TextEditingControllers
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose(); // Liberar el controlador del email
    dniController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
