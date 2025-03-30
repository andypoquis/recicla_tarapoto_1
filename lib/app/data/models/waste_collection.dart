// lib/app/data/models/waste_collection.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'residue_item.dart'; // Importa la clase anterior

class WasteCollectionModel {
  final String id;
  final String address;
  final bool isRecycled;
  final double totalBags;
  final double totalCoins;
  final double totalKg;
  final int correctlySegregated;
  final List<ResidueItem> residues; // Aquí usamos la lista de ResidueItem
  final DocumentReference? userReference;
  final DateTime? date;

  WasteCollectionModel({
    required this.id,
    required this.address,
    required this.isRecycled,
    required this.totalBags,
    required this.totalCoins,
    required this.totalKg,
    required this.correctlySegregated,
    required this.residues,
    required this.userReference,
    required this.date,
  });

  factory WasteCollectionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WasteCollectionModel(
      id: doc.id,
      address: data['address'] ?? '',
      isRecycled: data['isRecycled'] ?? false,
      totalBags: _toDouble(data['totalBags']),
      totalCoins: _toDouble(data['totalCoins']),
      totalKg: _toDouble(data['totalKg']),
      correctlySegregated: data['correctlySegregated'] ?? 0,
      userReference: data['userReference'] ?? '',
      date: (data['date'] is Timestamp)
          ? (data['date'] as Timestamp).toDate()
          : null,
      residues: (data['residues'] as List<dynamic>? ?? [])
          .map((item) => ResidueItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'address': address,
      'isRecycled': isRecycled,
      'totalBags': totalBags,
      'totalCoins': totalCoins,
      'totalKg': totalKg,
      'correctlySegregated': correctlySegregated,
      'userReference': userReference,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'residues': residues.map((r) => r.toMap()).toList(),
    };
  }

  // Actualizar campos particulares
  WasteCollectionModel copyWith({
    bool? isRecycled,
    List<ResidueItem>? residues,
  }) {
    return WasteCollectionModel(
      id: id,
      address: address,
      isRecycled: isRecycled ?? this.isRecycled,
      totalBags: totalBags,
      totalCoins: totalCoins,
      totalKg: totalKg,
      correctlySegregated: correctlySegregated,
      residues: residues ?? this.residues,
      userReference: userReference,
      date: date,
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
