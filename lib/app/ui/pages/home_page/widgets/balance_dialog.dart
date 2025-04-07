import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/home_controller.dart';

class BalanceDialog extends StatelessWidget {
  const BalanceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Mis Monedas",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Usamos Obx para que se reactive automáticamente
                    Obx(
                      () => Text(
                        "${homeController.totalCoins.value}\$",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Sección "En proceso"
              const Text(
                "En proceso",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              _ItemRowWidget(title: "Abono", date: "12/09/2024", points: "23"),
              const SizedBox(height: 20),
              // Sección "Canjeados"
              const Text(
                "Canjeados",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              _ItemRowWidget(
                  title: "Llavero", date: "05/05/2024", points: "12"),
              const SizedBox(height: 10),
              _ItemRowWidget(
                  title: "Llavero", date: "12/03/2024", points: "12"),
              const SizedBox(height: 20),
              // Sección "Cómo conseguir más monedas"
              const Text(
                "Como conseguir más monedas",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "1. Recuerda que cada tipo de residuo debe estar en una bolsa individual. Esto facilitará su segregación y hará que sea mucho más eficiente.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "2. Equivalencias por cada Kg de tipo de residuo:",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  for (var item in [
                    ["Papel/Cartón:", "6 Monedas"],
                    ["Plástico:", "7 Monedas"],
                    ["Metales:", "10 Monedas"],
                    ["Tetra Pack:", "5 Monedas"],
                    ["Vidrio:", "3 Monedas"]
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item[0],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            item[1],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget (antes `_buildItemRow`) que muestra el título, la fecha y la cantidad de puntos.
class _ItemRowWidget extends StatelessWidget {
  final String title;
  final String date;
  final String points;

  const _ItemRowWidget({
    Key? key,
    required this.title,
    required this.date,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF59D999),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$points\$",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
