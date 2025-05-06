// lib/app/model/carousel_image.dart

class CarouselImage {
  final String? id;
  final String url;
  final String tipo; // 👈 Nuevo campo: 'participacion' o 'premiacion'

  CarouselImage({
    this.id,
    required this.url,
    required this.tipo,
  });

  /// Convierte un documento de Firestore a nuestro modelo [CarouselImage].
  factory CarouselImage.fromFirestore(Map<String, dynamic> data, String docId) {
    return CarouselImage(
      id: docId,
      url: data['url'] ?? '',
      tipo: data['tipo'] ?? 'participacion', // Valor por defecto si no viene
    );
  }

  /// Convierte este modelo a un mapa para enviar a Firestore (si fuera necesario).
  Map<String, dynamic> toFirestore() {
    return {
      'url': url,
      'tipo': tipo,
    };
  }
}
