// lib/app/model/carousel_image.dart

class CarouselImage {
  final String? id;
  final String url;

  CarouselImage({
    this.id,
    required this.url,
  });

  /// Convierte un documento de Firestore a nuestro modelo [CarouselImage].
  factory CarouselImage.fromFirestore(Map<String, dynamic> data, String docId) {
    return CarouselImage(
      id: docId,
      url: data['url'] ?? '',
    );
  }

  /// Convierte este modelo a un mapa para enviar a Firestore (si fuera necesario).
  Map<String, dynamic> toFirestore() {
    return {
      'url': url,
    };
  }
}
