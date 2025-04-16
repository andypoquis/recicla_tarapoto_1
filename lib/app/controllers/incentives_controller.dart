// lib/app/controllers/incentives_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/incentive.dart';
import '../data/provider/incentives_provider.dart';

class IncentivesController extends GetxController {
  final IncentivesProvider _provider = IncentivesProvider();

  // Acceso a GetStorage para leer el userId
  final GetStorage _box = GetStorage('GlobalStorage');

  /// Lista observable de incentivos
  RxList<Incentive> incentivesList = <Incentive>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initIncentivesListener();
  }

  /// Suscribirse a la colección incentives.
  void _initIncentivesListener() {
    _provider.getIncentives().listen((incentives) {
      incentivesList.value = incentives;
    });
  }

  /// Método principal para canjear un incentivo
  /// Primero verifica si el usuario tiene suficientes monedas
  /// Si sí, guarda el canje en la subcolección redeemedIncentives.
  Future<void> redeemIncentive(Incentive incentive) async {
    try {
      final Map<String, dynamic>? userData = _box.read('userData');
      if (userData == null) {
        // No hay info del usuario
        Get.snackbar(
          'Error',
          'No se encontró información del usuario',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Puede estar en userData['id'] o userData['uid'], depende de tu login
      final String? userId = userData['id'] ?? userData['uid'];
      if (userId == null) {
        Get.snackbar(
          'Error',
          'No se encontró el ID del usuario',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 1) Obtenemos las monedas actuales
      final double currentCoins = await _getCurrentUserCoins(userId);

      // 2) Verificamos si alcanza para el precio del incentivo
      if (currentCoins < incentive.price) {
        // No alcanza
        Get.snackbar(
          'Monedas Insuficientes',
          'No tienes suficientes monedas para canjear este incentivo.',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // 3) Hacemos el "registro" del canje en la subcolección
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDocRef.collection('redeemedIncentives').add({
        'incentiveId': incentive.id, // si tu modelo de Incentive tiene un id
        'name': incentive.name,
        'description': incentive.description,
        'price': incentive.price, // costo en monedas
        'image': incentive.image,
        'redeemedCoins': incentive.price, // cuántas monedas se gastaron
        'status': 'pendiente',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4) Si quieres, puedes mostrar un snackbar de éxito aquí (o en la UI)
      Get.snackbar(
        '¡Felicidades!',
        'Has canjeado el incentivo correctamente.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Error al canjear incentivo: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error al canjear el incentivo.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Método privado para obtener las monedas totales del usuario,
  /// basadas en la suma de wasteCollections.totalCoins - suma de redeemedIncentives.redeemedCoins
  Future<double> _getCurrentUserCoins(String userId) async {
    double sumWasteCollections = 0.0;
    double sumRedeemedIncentives = 0.0;

    // Referencia al doc del usuario
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // 1) Sumar totalCoins de wasteCollections donde userReference == userRef y isRecycled == true
    final wasteCollectionsSnap = await FirebaseFirestore.instance
        .collection('wasteCollections')
        .where('userReference', isEqualTo: userRef)
        .where('isRecycled', isEqualTo: true)
        .get();

    for (var doc in wasteCollectionsSnap.docs) {
      final data = doc.data();
      final num? totalCoins = data['totalCoins'];
      if (totalCoins != null) {
        sumWasteCollections += totalCoins.toDouble();
      }
    }

    // 2) Sumar redeemedCoins de la subcolección redeemedIncentives
    final redeemedSnap = await userRef.collection('redeemedIncentives').get();
    for (var doc in redeemedSnap.docs) {
      final data = doc.data();
      final num? redeemedCoins = data['redeemedCoins'];
      if (redeemedCoins != null) {
        sumRedeemedIncentives += redeemedCoins.toDouble();
      }
    }

    // 3) Calculamos las monedas disponibles
    final currentCoins = sumWasteCollections - sumRedeemedIncentives;
    return currentCoins;
  }

  // Métodos extra de tu Provider:
  Future<void> addIncentive(Incentive incentive) async {
    await _provider.addIncentive(incentive);
  }

  Future<void> updateIncentive(String id, Incentive incentive) async {
    await _provider.updateIncentive(id, incentive);
  }

  Future<void> deleteIncentive(String id) async {
    await _provider.deleteIncentive(id);
  }
}
