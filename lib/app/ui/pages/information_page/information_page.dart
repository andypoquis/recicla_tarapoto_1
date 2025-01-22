import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/information_controller.dart';

class InformationScreen extends GetView<InformationController> {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> descriptions = [
      "Cada establecimiento puede producir diferentes cantidades y tipos de residuos, esto según su tipo de actividades, consumo de productos, o a las actividades a las que se dedique.",
      "La recolección de residuos en nuestra ciudad tiene horarios y también días preestablecidos para cada sector. Los sectores cuentan con jirones o avenidas según su ubicación.",
      "Al llenarse el camión, se transporta los residuos recolectados a las celdas de tratamiento que están ubicadas en Yacucatina a 45 minutos de la ciudad de Tarapoto.",
      "Al llegar los residuos a disposición final se vierte en las fosas de tratamiento, se esparce una capa de tierra. El proceso se repite hasta alcanzar la máxima capacidad.",
      "El equipo de la Unidad de Residuos Sólidos de la Municipalidad de San Martín monitorea constantemente las diferentes etapas del proceso asegurando un buen funcionamiento.",
    ];

    final List<String> titles = [
      "Generación de Residuos",
      "Recolección de Residuos",
      "Transporte de Residuos",
      "Disposición Final",
      "Monitoreo y Mantenimiento",
    ];

    final List<String> imagePaths = [
      'lib/assets/info1a.png',
      'lib/assets/info4a.png',
      'lib/assets/info2a.png',
      'lib/assets/info5a.png',
      'lib/assets/info3a.png',
    ];

    final List<String> segregationTitles = [
      "Segregación de Residuos",
      "¿Cómo Segregar?",
      "Residuos Orgánicos",
      "Residuos Inorgánicos",
      "Residuos No Aprovechables",
      "Gestión de Residuos Sólidos",
    ];

    final List<String> segregationDescriptions = [
      "Consiste en clasificar los desechos según su clasificación (orgánico, inorgánico o no aprovechables) para facilitar su reciclaje, reutilización o disposición final adecuada.\n"
          "Al segregar contribuimos a disminuir la cantidad de basura que llega a los vertederos, ahorramos recursos y promovemos una economía circular.",
      "La segregación efectiva implica depositar los residuos orgánicos, inorgánicos y no aprovechables en recipientes individuales.\n"
          "De forma alternativa, existen formas de tratar nuestros residuos, lo cual se explica de manera mas detallada en los siguientes cuadros.",
      "Previo tratamiento que se puede dar en nuestros hogares, estos desechos pueden ser aprovechados, ya que después de un proceso natural, los residuos orgánicos se convierten en abono de alta calidad.\n"
          "Cada hogar puede ser parte de la solución al implementar prácticas de segregación de residuos orgánicos.",
      "Para reciclar a gran medida los residuos inorgánicos, se requiere de procesos específicos para su gestión y a menudo se transforman en nuevos productos.\n"
          "En Tarapoto existe un proceso de recolección puerta a puerta para recolectar los diferentes tipos de residuos inorgánicos.",
      "Los residuos no aprovechables deben ser enviados a los rellenos sanitarios diseñados para contener tratar y minimizar  a gran medida su impacto ambiental.\n"
          "Tarapoto cuenta con un relleno sanitario que procesa estos residuos, evitando riesgos para la población y el medio ambiente.",
      "Los beneficios de una buena gestión y segregación de los residuos desde nuestros hogares son innumerables, y poniendo nuestro granito de arena haremos que esto funcione. Cada pequeño esfuerzo cuenta. ¡Hagamos de nuestro Tarapoto un lugar más sostenible!",
    ];

    final List<String> segregationImages = [
      'lib/assets/info1b.png',
      'lib/assets/info2b.png',
      'lib/assets/info3b.png',
      'lib/assets/info4b.png',
      'lib/assets/info5b.png',
      'lib/assets/info6b.png',
    ];

    final List<String> simpleTitles = [
      "Generación de Residuos",
      "Recolección de Residuos",
      "Transporte de Residuos",
      "Disposición Final",
    ];

    final List<String> simpleDescriptions = [
      "Así como beneficios económicos, al reciclar productos comunes en nuestros hogares como botellas de vidrios convertidos en vasos, o embaces plásticos en macetas.\n\n"
          "La segregación y el reciclaje de inorgánicos en la fuente es el primer paso para cultivar una cultura de cuidado ambiental en cada hogar.",
      "Menos volumen de residuos a la hora de la recolección, permitiendo abarcar mayor territorio con menos tiempo  y menos recursos.\n\n"
          "Minimización de riesgo de accidentes laborales durante la recolección, como cortes por vidrios o bultos demasiado pesados.",
      "Menos volumen de residuos, significa menos viajes al relleno, menor consumo de combustible, mayor ahorro de recursos económicos y prolongación de la vida útil de los vehículos recolectores.\n\n"
          "Así como la disminución de emisión de gases de efecto invernadero por parte de los vehículos recolectores.",
      "Los inorgánicos tienen un tiempo prolongado de descomposición por ende permanecen mucho más tiempo en los rellenos sanitarios ocupando espacio.\n\n"
          "Al reducir el volumen de residuos inorgánicos, se extiende la vida útil de los rellenos sanitarios y se posterga la necesidad de abrir nuevos.",
    ];

    final PageController simplePageController = PageController();
    final RxInt simpleCurrentPage = 0.obs;
    final PageController pageController = PageController();
    final RxInt currentPage = 0.obs; // Página seleccionada reactiva
    final RxInt segregationPage =
        0.obs; // Página seleccionada del segundo carrusel

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información sobre Reciclaje',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '¿Por qué es importante reciclar?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "El reciclaje es fundamental para reducir la contaminación ambiental y conservar recursos naturales. "
                "Al reciclar, ayudamos a disminuir la cantidad de basura enviada a los vertederos, lo cual es clave para un desarrollo sostenible.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Etapas de la Gestión de Residuos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Primer carrusel
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (index) {
                        currentPage.value = index;
                      },
                      itemCount: descriptions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Image.asset(
                                    imagePaths[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    color: const Color(0xFF59D999),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          titles[index],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          descriptions[index],
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(descriptions.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage.value == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentPage.value == index
                                  ? const Color(0xFFFFFFFF)
                                  : const Color.fromRGBO(63, 188, 159, 1),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Principales Problemas de la Gestión de Residuos Sólidos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Segundo carrusel
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        segregationPage.value = index;
                      },
                      itemCount: segregationTitles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                // Contenido de texto arriba
                                Container(
                                  width: double.infinity,
                                  color: const Color(0xFF59D999),
                                  padding: const EdgeInsets.all(16.0),
                                  child: index == segregationTitles.length - 1
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Gestión de Residuos Sólidos",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Los beneficios de una buena gestión y segregación de los residuos desde nuestros hogares son innumerables, y poniendo nuestro granito de arena haremos que esto funcione.",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "Cada pequeño esfuerzo cuenta.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "¡Hagamos de nuestro Tarapoto un lugar más sostenible!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              segregationTitles[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              segregationDescriptions[index],
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                // Imagen debajo
                                Expanded(
                                  child: Image.asset(
                                    segregationImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(segregationTitles.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: segregationPage.value == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: segregationPage.value == index
                                  ? const Color(0xFFFFFFFF)
                                  : const Color.fromRGBO(63, 188, 159, 1),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Principales Beneficios al Segregar y Reciclar Residuos Inorgánicos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: simplePageController,
                      onPageChanged: (index) {
                        simpleCurrentPage.value = index;
                      },
                      itemCount: simpleTitles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: const Color(0xFF59D999),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    simpleTitles[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    simpleDescriptions[index],
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(simpleTitles.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: simpleCurrentPage.value == index ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: simpleCurrentPage.value == index
                                  ? const Color(0xFFFFFFFF)
                                  : const Color.fromRGBO(63, 188, 159, 1),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
