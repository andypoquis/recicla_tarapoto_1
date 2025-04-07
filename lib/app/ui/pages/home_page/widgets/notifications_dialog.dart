import 'package:flutter/material.dart';

class NotificationsDialog extends StatelessWidget {
  const NotificationsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordes redondeados
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF31ADA0), // Fondo verde
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Center(
                child: Text(
                  "Anuncios Importantes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Lista de Anuncios
              Column(
                children: [
                  for (var item in [
                    {
                      "title": "Incentivo",
                      "date": "12/09/2024",
                      "description":
                          "Canjeaste el incentivo “Abono” de 23 Monedas."
                    },
                    {
                      "title": "Monedas",
                      "date": "10/09/2024",
                      "description":
                          "Recibiste un total de 30 monedas por tu entrega de residuos aprovechables."
                    },
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título y Fecha en paralelo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item["title"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item["date"]!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Descripción
                            Text(
                              item["description"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
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
