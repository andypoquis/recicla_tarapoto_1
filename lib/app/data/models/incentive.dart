// lib/app/model/incentive.dart
class Incentive {
  final String? id; // ID del documento en Firestore
  final String description;
  final String image;
  final String name;
  final int price;
  final int stock; // NUEVO: unidades disponibles para canje

  Incentive({
    this.id,
    required this.description,
    required this.image,
    required this.name,
    required this.price,
    this.stock = 0, // default para no romper llamados existentes
  });

  /// Atajos útiles para la UI
  bool get isAvailable => stock > 0;

  /// Convierte los datos de Firestore a nuestro modelo [Incentive].
  factory Incentive.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return Incentive(
      id: documentId,
      description: (data['description'] ?? '') as String,
      image: (data['image'] ?? '') as String,
      name: (data['name'] ?? '') as String,
      price: ((data['price'] ?? 0) as num).toInt(),
      stock: ((data['stock'] ?? 0) as num).toInt(), // NUEVO
    );
  }

  /// Convierte este modelo a un mapa para enviar a Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'image': image,
      'name': name,
      'price': price,
      'stock': stock, // NUEVO
    };
  }

  /// copyWith para actualizaciones locales (ej. refrescar stock en memoria)
  Incentive copyWith({
    String? id,
    String? description,
    String? image,
    String? name,
    int? price,
    int? stock,
  }) {
    return Incentive(
      id: id ?? this.id,
      description: description ?? this.description,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  @override
  String toString() =>
      'Incentive(id: $id, name: $name, price: $price, stock: $stock)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Incentive &&
        other.id == id &&
        other.description == description &&
        other.image == image &&
        other.name == name &&
        other.price == price &&
        other.stock == stock;
  }

  @override
  int get hashCode => Object.hash(id, description, image, name, price, stock);
}
