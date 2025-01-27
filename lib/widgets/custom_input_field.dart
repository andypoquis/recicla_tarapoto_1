import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Function(String)? onChanged;

  CustomInputField({
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.width,
    this.height,
    this.textStyle,
    this.onChanged,
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;

  /// `showIcon` controlará si el ícono se ve o no.
  bool showIcon = true;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    // Listener para cambios de foco
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          // Al hacer foco, ocultamos el ícono
          showIcon = false;
        } else {
          // Al perder el foco, mostramos el ícono si el campo está vacío
          showIcon = widget.controller?.text.isEmpty ?? true;
        }
      });
    });

    // Listener para cambios de texto
    widget.controller?.addListener(() {
      // Si el campo NO está enfocado, verifica si debe mostrar el ícono
      if (!_focusNode.hasFocus) {
        setState(() {
          showIcon = widget.controller?.text.isEmpty ?? true;
        });
      }
      // Si está enfocado, se mantiene oculto
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: widget.textStyle ?? const TextStyle(color: Colors.white),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.textStyle?.copyWith(
                color: const Color.fromARGB(255, 255, 255, 255),
              ) ??
              const TextStyle(color: Colors.white70),

          // Solo mostramos el ícono si `showIcon` es true
          prefixIcon: showIcon ? Icon(widget.icon, color: Colors.white) : null,

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
