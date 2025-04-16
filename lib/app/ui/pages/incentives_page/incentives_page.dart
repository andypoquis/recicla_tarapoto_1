import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncentivesScreen extends StatelessWidget {
  const IncentivesScreen({Key? key}) : super(key: key);

  // Colores primarios usados en tu app:
  static const Color primaryColorDark = Color(0xFF31ADA0);
  static const Color primaryColorLight = Color(0xFF59D999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            const Text(
              "Incentivos Canjeados",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 102, 102, 102),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // 1) Traemos TODOS los documentos de la subcolección 'redeemedIncentives' de TODOS los usuarios
                stream: FirebaseFirestore.instance
                    .collectionGroup('redeemedIncentives')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Ocurrió un error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay incentivos canjeados.'),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // Usamos GridView para ejemplificar, puedes cambiar a ListView.builder si lo prefieres
                  return GridView.builder(
                    itemCount: docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.60,
                    ),
                    itemBuilder: (context, index) {
                      final docSnap = docs[index];
                      final data = docSnap.data() as Map<String, dynamic>?;

                      // Si el doc no tiene data, retornamos algo vacío
                      if (data == null) {
                        return const SizedBox();
                      }

                      // Obtenemos la referencia al documento de usuario
                      // parent => 'redeemedIncentives', parent.parent => '/users/<uid>'
                      final userDocRef = docSnap.reference.parent.parent;
                      if (userDocRef == null) {
                        // Si no existe la referencia padre, no podemos mostrar datos del user
                        return const SizedBox();
                      }

                      // 2) FutureBuilder para traer datos del usuario (name, lastname, address, etc.)
                      return FutureBuilder<DocumentSnapshot>(
                        future: userDocRef.get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (userSnapshot.hasError) {
                            return const Center(
                                child: Text('Error al cargar usuario'));
                          }

                          // Datos del usuario
                          String userFullName = '';
                          String userAddress = '';

                          if (userSnapshot.hasData &&
                              userSnapshot.data!.exists) {
                            final userData = userSnapshot.data!.data()
                                as Map<String, dynamic>?;
                            if (userData != null) {
                              final userName = userData['name'] ?? '';
                              final userLastName = userData['lastname'] ?? '';
                              userFullName = '$userName $userLastName'.trim();
                              userAddress = userData['address'] ?? '';
                            }
                          }

                          // Datos del incentivo canjeado
                          final incentiveName = data['name'] ?? '';
                          final description = data['description'] ?? '';
                          final price = data['price']?.toString() ?? '';
                          final imageUrl = data['image'] ?? '';
                          final status = data['status'] ?? 'pendiente';

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [primaryColorDark, primaryColorLight],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Imagen
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.broken_image,
                                              size: 60,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: 100,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Nombre del incentivo
                                    Text(
                                      incentiveName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Descripción del incentivo
                                    Text(
                                      description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    // Precio
                                    Text(
                                      'Costo: $price monedas',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Espacio
                                    const SizedBox(height: 8),
                                    // Estado
                                    Row(
                                      children: [
                                        const Text(
                                          'Estado: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          status,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: (status == 'pendiente')
                                                ? Colors.amberAccent
                                                : Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Divider
                                    Container(
                                      height: 1,
                                      color: Colors.white54,
                                    ),
                                    const SizedBox(height: 8),
                                    // Información del usuario (nombre y dirección)
                                    Text(
                                      userFullName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userAddress,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
