import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/incentives_controller.dart';

class IncentivesScreen extends GetView<IncentivesController> {
  const IncentivesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ==== Layout del grid (sin overflow) ====
    const outerPadding = 8.0;
    const crossAxisSpacing = 12.0;
    const mainAxisSpacing = 12.0;
    const crossAxisCount = 2;

    final gridItemWidth = (size.width -
            (outerPadding * 2) -
            (crossAxisSpacing * (crossAxisCount - 1))) /
        crossAxisCount;

    // Alto objetivo por card (ajusta según pantallas angostas)
    final desiredHeight = size.width < 380 ? 390.0 : 370.0;
    final cardAspectRatio = gridItemWidth / desiredHeight;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(outerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            const Text(
              "Incentivos Disponibles",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                final incentives = controller.incentivesList;
                if (incentives.isEmpty) {
                  return const Center(
                    child: Text('No hay incentivos disponibles.',
                        style: TextStyle(fontSize: 16)),
                  );
                }

                return GridView.builder(
                  itemCount: incentives.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                  ).copyWith(childAspectRatio: cardAspectRatio),
                  itemBuilder: (context, i) {
                    final inc = incentives[i];
                    return IncentiveCard(
                      name: inc.name,
                      price: inc.price,
                      description: inc.description,
                      imageUrl: inc.image,
                      stock: inc.stock,
                      onRedeem: () => _openRedeemDialog(context, inc),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _openRedeemDialog(BuildContext context, dynamic inc) {
    final bool sinStock = inc.stock <= 0;
    if (sinStock) {
      Get.snackbar('Sin stock', 'Este incentivo ya no está disponible.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final bool sinStockDialog = inc.stock <= 0;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.monetization_on,
                          color: Color(0xFF31ADA0), size: 30),
                      SizedBox(width: 8),
                      Text("150 Monedas",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      inc.image,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 140,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image,
                            size: 60, color: Colors.grey),
                      ),
                      loadingBuilder: (context, child, loading) {
                        if (loading == null) return child;
                        return const SizedBox(
                          height: 140,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(inc.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Costo: ${inc.price} monedas",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: sinStockDialog
                          ? Colors.redAccent
                          : const Color(0x1431ADA0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sinStockDialog
                          ? 'Sin stock'
                          : 'Stock disponible: ${inc.stock}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: sinStockDialog
                            ? Colors.white
                            : const Color(0xFF31ADA0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(inc.description,
                      textAlign: TextAlign.justify,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                  const Divider(height: 30),
                  const Text("Proceso para recibir tu premio:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text(
                    "- Una vez confirmado el canje, se descontarán las monedas de tu cuenta.\n"
                    "- El equipo de ReciclaTarapoto te contactará en un plazo de 48 horas.\n"
                    "- Deberás acercarte a nuestras oficinas con tu DNI para recoger el premio.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Cerrar"),
                      ),
                      ElevatedButton(
                        onPressed: inc.stock <= 0
                            ? null
                            : () async {
                                await controller.redeemIncentive(inc);
                                Navigator.of(ctx).pop();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF31ADA0),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Confirmar Canje"),
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
  }
}

class IncentiveCard extends StatelessWidget {
  const IncentiveCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.onRedeem,
  });

  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final int stock;
  final VoidCallback onRedeem;

  // Paleta (Recicla Tarapoto)
  static const Color kPrimary = Color(0xFF31ADA0); // celeste/verde
  static const Color kPrimary2 = Color(0xFF59D999);
  static const Color kPrimaryDark = Color(0xFF136F66);

  @override
  Widget build(BuildContext context) {
    final agotado = stock <= 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
// ===== Zona superior: Imagen full-bleed con solo esquinas superiores redondeadas =====
          AspectRatio(
            aspectRatio:
                1 / 1, // puedes subir a 4/3 si la quieres un poquito más alta
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen cubriendo toda el área superior
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover, // mantiene full-bleed
                    alignment: Alignment.center,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 150),
                    useOldImageOnUrlChange:
                        true, // evita “parpadeo” al reciclar widgets
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image,
                          size: 60, color: Colors.grey),
                    ),
                  ),

                  // (Opcional) una veladura muy sutil para que no se “queme” en fotos claras
                  // Container(color: Colors.black12),

                  // Overlay de AGOTADO si aplica
                  if (stock <= 0)
                    Container(
                      color: Colors.black.withOpacity(0.35),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'AGOTADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ===== Panel blanco con info =====
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Chip de stock
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: agotado
                            ? Colors.redAccent
                            : const Color(0x1431ADA0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: agotado
                              ? Colors.redAccent
                              : const Color(0x2231ADA0),
                        ),
                      ),
                      child: Text(
                        agotado ? 'Sin stock' : 'Stock: $stock',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: agotado ? Colors.white : kPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Descripción
                    // Descripción (justificada)
                    Expanded(
                      child: Text(
                        description,
                        maxLines: 4, // antes 3
                        textAlign: TextAlign.justify, // 👈 justificar
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                    ),

                    // ===== Footer: Precio + Botón =====
                    Row(
                      children: [
                        // Bloque de precio
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PRECIO',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black45,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              "\$${price.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),

                        // Botón Canjear (full para el resto del ancho)
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: agotado ? null : onRedeem,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    agotado ? Colors.black12 : kPrimary,
                                foregroundColor:
                                    agotado ? Colors.black45 : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Canjear',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

// Helper para ajustar childAspectRatio
extension _SliverGridDelegateCopy on SliverGridDelegateWithFixedCrossAxisCount {
  SliverGridDelegateWithFixedCrossAxisCount copyWith({
    int? crossAxisCount,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double? childAspectRatio,
  }) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount ?? this.crossAxisCount,
      mainAxisSpacing: mainAxisSpacing ?? this.mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing ?? this.crossAxisSpacing,
      childAspectRatio: childAspectRatio ?? this.childAspectRatio,
    );
  }
}
