import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/home_controller.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/homecollector_page/homecollector_page.dart';
import 'package:recicla_tarapoto_1/app/ui/pages/userinventory_page/userinventory_page.dart';

// Páginas para el usuario "normal"
import '../home_screen/home_screen.dart';
import '../incentives_page/incentives_page.dart';
import '../information_page/information_page.dart';
import '../notifications_page/notifications_page.dart';
import '../user_page/user_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos Obx para que se reconstruya cuando cambie isCollector o selectedIndex
    return Obx(() {
      // Leemos si el usuario es collector o no
      final bool isCollector = controller.isCollector.value;

      // Definimos las páginas para usuario normal
      final List<Widget> pagesUser = [
        HomeScreen(),
        InformationScreen(),
        IncentivesScreen(),
        UserScreen(),
      ];

      // Definimos las páginas para collector
      final List<Widget> pagesCollector = [
        HomecollectorPage(),
        UserinventoryPage(),
        NotificationsPage(),
        //ProfilecollectorPage(),
        UserScreen(),
      ];

      // Definimos los items del BottomNavigationBar para usuario normal
      final List<BottomNavigationBarItem> itemsUser = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ];

      // Definimos los items del BottomNavigationBar para collector
      final List<BottomNavigationBarItem> itemsCollector = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_repair_service),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: '',
        ),
      ];

      // Según el valor de isCollector tomamos una lista de páginas u otra
      final pages = isCollector ? pagesCollector : pagesUser;
      // Según el valor de isCollector tomamos un BottomNavigationBarItem u otro
      final items = isCollector ? itemsCollector : itemsUser;

      return Scaffold(
        // AppBar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // Logo
              Image.asset(
                'lib/assets/logo_completo.png',
                height: 39,
              ),
            ],
          ),
          actions: [
            // Ícono de notificaciones
            Transform.translate(
              offset: const Offset(-12, 0),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    color: Colors.white,
                    iconSize: 33,
                    onPressed: () {
                      // Muestra el diálogo al presionar el ícono de notificaciones
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // Bordes redondeados
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
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            child: Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 5,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Título y Fecha en paralelo
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        item["title"]!,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                    textAlign:
                                                        TextAlign.justify,
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
                        },
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 1,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 89, 217, 153),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 21,
                        minHeight: 21,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Ícono de balance
            Transform.translate(
              offset: const Offset(-20, 0.0),
              child: IconButton(
                icon: const Icon(Icons.monetization_on),
                color: Colors.white,
                iconSize: 33,
                onPressed: () {
                  // Muestra el diálogo al presionar el ícono de "monetization"
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Bordes redondeados
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // Fondo blanco
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Título
                                Center(
                                  child: Column(
                                    children: const [
                                      Text(
                                        "Mis Monedas",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "50\$",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 0, 0, 0),
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
                                _buildItemRow("Abono", "12/09/2024", "23"),
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
                                _buildItemRow("Llavero", "05/05/2024", "12"),
                                const SizedBox(height: 10),
                                _buildItemRow("Llavero", "12/03/2024", "12"),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                    },
                  );
                },
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF59D999), Color(0xFF31ADA0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        // BODY: según la pestaña seleccionada
        body: Center(
          child: pages.elementAt(controller.selectedIndex.value),
        ),
        // BottomNavigationBar
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF31ADA0),
          ),
          child: BottomNavigationBar(
            items: items,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF59D999),
            unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 45,
            backgroundColor: const Color(0xFF31ADA0),
          ),
        ),
      );
    });
  }

  // Si necesitas acceder al método _buildItemRow desde un diálogo,
  // asegúrate de dejarlo como parte de la clase HomePage.
  Widget _buildItemRow(String title, String date, String points) {
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
