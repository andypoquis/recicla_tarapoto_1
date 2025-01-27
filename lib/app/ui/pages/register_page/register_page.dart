import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/widgets/custom_input_field.dart';
import '../../../controllers/register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF59D999), Color(0xFF31AD9B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 39),
                    Text(
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 42, // <-- reducido de 42 a 32
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Nombres',
                            icon: Icons.person,
                            controller: controller.nameController,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            label: 'Apellidos',
                            icon: Icons.person_add_alt_1_outlined,
                            controller: controller.lastNameController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildInputField(
                      label: 'Correo Electrónico',
                      icon: Icons.email_outlined,
                      controller: controller.emailController,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'DNI',
                            icon: Icons.edit_note_rounded,
                            controller: controller.dniController,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            label: 'Teléfono',
                            icon: Icons.phone,
                            controller: controller.phoneController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildInputField(
                      label: 'Dirección',
                      icon: Icons.location_on_outlined,
                      controller: controller.addressController,
                    ),
                    _buildInputField(
                      label: 'Contraseña',
                      icon: Icons.lock,
                      controller: controller.passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Tipo de Usuario',
                      style: TextStyle(
                        fontSize: 16, // <-- reducido de 21 a 16
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 0),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildRadioOption(
                            label: 'Casa',
                            value: 'Casa',
                            groupValue: controller.userType.value,
                            onChanged: (value) =>
                                controller.userType.value = value!,
                          ),
                          _buildRadioOption(
                            label: 'Institución',
                            value: 'Institución',
                            groupValue: controller.userType.value,
                            onChanged: (value) =>
                                controller.userType.value = value!,
                          ),
                          _buildRadioOption(
                            label: 'Negocio',
                            value: 'Negocio',
                            groupValue: controller.userType.value,
                            onChanged: (value) =>
                                controller.userType.value = value!,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        width: 276,
                        child: Obx(() {
                          return controller.isLoading.value
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    controller.registerUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'REGISTRARSE',
                                    style: TextStyle(
                                      color:
                                          const Color.fromRGBO(50, 174, 161, 1),
                                      fontSize: 18, //
                                    ),
                                  ),
                                );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16, // <-- reducido de 21 a 16
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        CustomInputField(
          hintText: '',
          icon: icon,
          controller: controller,
          obscureText: obscureText,
          width: double.infinity,
          height: 45,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize:
                15, // <-- ajusta si quieres hacer aún más pequeña la entrada
          ),
        ),
        SizedBox(height: 0),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12, // <-- reduce si quieres los textos de los Radios
          ),
        ),
      ],
    );
  }
}
