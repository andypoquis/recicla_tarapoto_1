import 'package:cloud_firestore/cloud_firestore.dart';

class RedeemedIncentiveModel {
  final String id; // ID del doc en 'redeemedIncentives'
  final DocumentReference
      docRef; // Referencia directa al documento (para actualizar)

  // Referencias e IDs
  final String? incentiveId;
  final DocumentReference? incentiveRef; // NUEVO: referencia al incentivo
  final DocumentReference? userRef; // NUEVO: referencia al usuario

  // Datos del incentivo
  final String name;
  final String description;
  final double price; // Precio unitario (monedas)
  final int qty; // NUEVO: cantidad canjeada (default 1)
  final double redeemedCoins; // Monedas gastadas (price * qty)
  final String status; // "pendiente" | "completado" | etc.
  final String image;
  final Timestamp? createdAt;
  final String? idempotencyKey; // NUEVO: para evitar duplicados

  // Información del usuario guardada en el doc
  final String userName;
  final String userAddress;

  // Getters de conveniencia
  double get totalCoins => price * qty;
  bool get isPending => status.toLowerCase() == 'pendiente';
  bool get isCompleted => status.toLowerCase() == 'completado';

  RedeemedIncentiveModel({
    required this.id,
    required this.docRef,
    required this.incentiveId,
    required this.name,
    required this.description,
    required this.price,
    required this.qty,
    required this.redeemedCoins,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.userName,
    required this.userAddress,
    this.incentiveRef,
    this.userRef,
    this.idempotencyKey,
  });

  factory RedeemedIncentiveModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return RedeemedIncentiveModel(
      id: doc.id,
      docRef: doc.reference,
      incentiveId: data['incentiveId'] as String?,
      incentiveRef: data['incentiveRef'] as DocumentReference?,
      userRef: data['userRef'] as DocumentReference?,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: toDouble(data['price']),
      qty: (data['qty'] is num) ? (data['qty'] as num).toInt() : 1,
      redeemedCoins: toDouble(data['redeemedCoins']),
      status: data['status'] ?? 'pendiente',
      image: data['image'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt'] as Timestamp
          : null,
      idempotencyKey: data['idempotencyKey'] as String?,
      userName: data['userName'] ?? '',
      userAddress: data['userAddress'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (incentiveId != null) 'incentiveId': incentiveId,
      'name': name,
      'description': description,
      'price': price,
      'qty': qty,
      'redeemedCoins': redeemedCoins,
      'status': status,
      'image': image,
      if (createdAt != null) 'createdAt': createdAt,
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      if (incentiveRef != null) 'incentiveRef': incentiveRef,
      if (userRef != null) 'userRef': userRef,
      'userName': userName,
      'userAddress': userAddress,
    };
  }

  static double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
