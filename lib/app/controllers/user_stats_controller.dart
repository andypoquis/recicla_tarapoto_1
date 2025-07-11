import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';

class UserStatsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController _userController = Get.find<UserController>();
  
  // Variables observables para estadísticas
  final RxDouble totalKgReciclados = 0.0.obs;
  final RxInt totalRecolecciones = 0.obs;
  final RxInt totalIncentivosCanjeados = 0.obs;
  
  // Estado de carga
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserStats();
  }

  /// Carga las estadísticas del usuario desde Firebase
  Future<void> loadUserStats() async {
    if (_userController.userModel.value == null) {
      print('No hay usuario logueado para cargar estadísticas');
      return;
    }

    isLoading.value = true;
    
    try {
      final String userId = _userController.userModel.value!.uid;
      
      // 1. Cargar datos de reciclaje (wasteCollections)
      await _loadRecyclingData(userId);
      
      // 2. Cargar datos de incentivos canjeados
      await _loadRedeemedIncentives(userId);
      
    } catch (e) {
      print('Error al cargar estadísticas del usuario: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga datos de reciclaje desde wasteCollections
  Future<void> _loadRecyclingData(String userId) async {
    try {
      print('Buscando datos de reciclaje para el usuario $userId');
      
      // Crear una referencia correcta al documento del usuario
      final userRef = _firestore.doc('users/$userId');
      
      // Buscar todas las colecciones de residuos recicladas del usuario
      final QuerySnapshot wasteCollections = await _firestore
          .collection('wasteCollections')
          .where('userReference', isEqualTo: userRef)
          .where('isRecycled', isEqualTo: true)
          .get();

      print('Se encontraron ${wasteCollections.docs.length} documentos de wasteCollections para el usuario');

      // Resetear contadores
      double totalKg = 0.0;
      int recolecciones = 0;

      // Sumar los totales de cada colección
      for (var doc in wasteCollections.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print('Procesando documento: ${doc.id}');
        
        // Sumar kg totales
        if (data.containsKey('totalKg')) {
          final kg = data['totalKg'];
          if (kg is num) {
            totalKg += kg.toDouble();
            print('Sumando $kg kg al total');
          }
        }
        
        // Contar como una recolección completada
        recolecciones++;
      }

      // Actualizar variables observables
      totalKgReciclados.value = totalKg;
      totalRecolecciones.value = recolecciones;
      
      print('Datos de reciclaje cargados: $totalKg kg, $recolecciones recolecciones');
      
    } catch (e) {
      print('Error al cargar datos de reciclaje: $e');
    }
  }

  /// Carga incentivos canjeados desde users/{userId}/redeemedIncentives
  Future<void> _loadRedeemedIncentives(String userId) async {
    try {
      // Buscar incentivos canjeados y completados
      final QuerySnapshot incentives = await _firestore
          .collection('users')
          .doc(userId)
          .collection('redeemedIncentives')
          .where('status', isEqualTo: 'completado')
          .get();

      // Contar incentivos completados
      totalIncentivosCanjeados.value = incentives.docs.length;
      
      print('Incentivos canjeados cargados: ${incentives.docs.length}');
      
    } catch (e) {
      print('Error al cargar incentivos canjeados: $e');
    }
  }

  /// Recarga todas las estadísticas del usuario
  void refreshStats() {
    loadUserStats();
  }
}
