// lib/app/model/incentive.dart
class Incentive {
  final String? id; // ID del documento en Firestore
  final String description;
  final String image;
  final String name;
  final int price;

  Incentive({
    this.id,
    required this.description,
    required this.image,
    required this.name,
    required this.price,
  });

  /// Convierte los datos de Firestore a nuestro modelo [Incentive].
  factory Incentive.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return Incentive(
      id: documentId,
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
    );
  }

  /// Convierte este modelo a un mapa para enviar a Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'image': image,
      'name': name,
      'price': price,
    };
  }
}
