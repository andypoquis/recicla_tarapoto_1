import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/widgets/custom_input_field.dart';

import '../../../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Permite que el contenido se ajuste al abrir el teclado
      body: Stack(
        children: [
          // Fondo con gradiente que ocupa toda la pantalla
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF59D999), Color(0xFF31AD9B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenido desplazable
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 47),
              height: MediaQuery.of(context)
                  .size
                  .height, // Hace que ocupe toda la pantalla
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        CustomInputField(
                          hintText: 'Ingresar email',
                          icon: Icons.email,
                          width: 300,
                          height: 48,
                          textStyle: TextStyle(color: Colors.white),
                          controller: controller
                              .emailController, // <-- Controlador asignado
                          onChanged: (value) => controller.email.value = value,
                        ),
                        SizedBox(height: 9),
                        Text(
                          'Contraseña',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        CustomInputField(
                          hintText: 'Ingresar Contraseña',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          width: 300,
                          height: 48,
                          textStyle: TextStyle(color: Colors.white),
                          controller: controller
                              .passwordController, // <-- Controlador asignado
                          onChanged: (value) =>
                              controller.password.value = value,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Recuperar Contraseña',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Obx(() {
                            return controller.isLoading.value
                                ? CircularProgressIndicator() // Mostrar un loading cuando se está autenticando
                                : SizedBox(
                                    width: 276,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.login();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      child: Text(
                                        'INGRESAR',
                                        style: TextStyle(
                                          color: const Color.fromRGBO(
                                              50, 174, 161, 1),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 45.0),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: '¿No tienes una cuenta? ',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'REGÍSTRATE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed('/register');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
