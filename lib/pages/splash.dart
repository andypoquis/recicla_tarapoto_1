import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/login_page/login_page.dart';

// Splash Screen que se muestra al inicio

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Para controlar la opacidad del logo

  @override
  void initState() {
    super.initState();

    // Inicia el efecto de fade in después de un pequeño retraso
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Aumenta la opacidad para el efecto de fade in
      });
    });

    // Navegar a la pantalla principal después de 3 segundos, con fade out
    Timer(Duration(seconds: 4), () {
      setState(() {
        _opacity = 0.0; // Reduce la opacidad para el efecto de fade out
      });

      // Espera a que el fade out termine antes de cambiar de pantalla
      Timer(Duration(milliseconds: 1000), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(89, 217, 153, 1),
              Color.fromRGBO(49, 173, 161, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity, // Controla la opacidad del logo
            duration: Duration(seconds: 1), // Duración del efecto de disolución
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/logo_completo.png',
                    width: 247, height: 250),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
