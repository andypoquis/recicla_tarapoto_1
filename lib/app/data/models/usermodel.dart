class UserModel {
  String address;
  String dni;
  String lastname;
  String name;
  String phoneNumber;
  bool iscollector;
  List<String> typeUser;
  String uid;

  UserModel({
    required this.address,
    required this.dni,
    required this.lastname,
    required this.name,
    required this.phoneNumber,
    required this.iscollector,
    required this.typeUser,
    required this.uid,
  });

  // Convierte un documento de Firestore en un modelo de usuario
  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      address: json['address'] ?? '',
      dni: json['dni'] ?? '',
      lastname: json['lastname'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      iscollector: json['iscollector'] ?? false,
      typeUser: List<String>.from(json['type_user'] ?? []),
      uid: json['uid'] ?? '',
    );
  }

  // Convierte el modelo de usuario a un formato compatible con Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'address': address,
      'dni': dni,
      'lastname': lastname,
      'name': name,
      'phone_number': phoneNumber,
      'iscollector': iscollector,
      'type_user': typeUser,
      'uid': uid,
    };
  }
}
