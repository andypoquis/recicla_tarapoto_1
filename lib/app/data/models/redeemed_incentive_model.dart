import 'package:cloud_firestore/cloud_firestore.dart';

class RedeemedIncentiveModel {
  final String id; // ID del doc en 'redeemedIncentives'
  final DocumentReference
      docRef; // Referencia directa al documento (para actualizar)
  final String? incentiveId;
  final String name; // Nombre del incentivo
  final String description; // Descripción del incentivo
  final double price; // Precio (monedas)
  final double redeemedCoins; // Monedas gastadas
  final String status; // "pendiente" | "completado"
  final String image; // URL de la imagen
  final Timestamp? createdAt; // Momento del canje

  // Información del usuario (guardada en el doc):
  final String userName; // Nombre del usuario
  final String userAddress; // Dirección del usuario

  RedeemedIncentiveModel({
    required this.id,
    required this.docRef,
    required this.incentiveId,
    required this.name,
    required this.description,
    required this.price,
    required this.redeemedCoins,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.userName,
    required this.userAddress,
  });

  factory RedeemedIncentiveModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RedeemedIncentiveModel(
      id: doc.id,
      docRef: doc.reference,
      incentiveId: data['incentiveId'],
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: _toDouble(data['price']),
      redeemedCoins: _toDouble(data['redeemedCoins']),
      status: data['status'] ?? 'pendiente',
      image: data['image'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt'] as Timestamp
          : null,
      userName: data['userName'] ?? '',
      userAddress: data['userAddress'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
