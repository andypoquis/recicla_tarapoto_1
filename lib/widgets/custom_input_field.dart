import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final double? width; // Nuevo parámetro para el ancho
  final double? height; // Nuevo parámetro para la altura
  final TextStyle? textStyle;
  final Function(String)?
      onChanged; // Nuevo parámetro para manejar cambios de texto

  CustomInputField({
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.width, // Nuevo
    this.height, // Nuevo
    this.textStyle,
    this.onChanged, // Nuevo
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity, // Ancho del campo de texto
      height: height, // Altura opcional
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: textStyle ?? TextStyle(color: Colors.white),
        onChanged: onChanged, // Ejecuta la función cuando el valor cambia
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyle?.copyWith(
              color: const Color.fromARGB(255, 255, 255, 255)),
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
