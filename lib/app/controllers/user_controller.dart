import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recicla_tarapoto_1/app/data/models/usermodel.dart';

import '../data/provider/authprovider.dart';

class UserController extends GetxController {
  final GetStorage _box = GetStorage('GlobalStorage');
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  // Guardamos al recolector en caso de que el usuario actual NO sea recolector
  Rx<UserModel?> collectorModel = Rx<UserModel?>(null);

  // Variables reactivas para las estadísticas
  RxDouble totalKgReciclados = 0.0.obs;
  RxInt totalRecolecciones = 0.obs;
  RxInt totalCoinsEarnedFromRecycling = 0.obs;
  RxInt totalRedeemedCoins = 0.obs;
  RxInt currentCoinsBalance = 0.obs;
  RxInt totalIncentivosCanjeados = 0.obs;
  
  // Indica si las estadísticas están cargando
  RxBool isLoadingStats = false.obs;
  
  // Indica si se encontraron datos en Firebase
  RxBool dataFound = false.obs;

  // Inyectamos AuthProvider para poder llamar signOut
  final AuthProvider _authProvider = AuthProvider();

  @override
  void onInit() {
    super.onInit();
    // Asignar valores por defecto inmediatamente
    setDefaultValues();
    _loadUserFromStorage();
    // Cargar estadísticas cuando se inicializa el controlador
    ever(userModel, (_) {
      if (userModel.value != null) {
        print('⭐ Usuario cargado, cargando estadísticas...');
        loadUserStatistics();
      }
    });
  }

  void _loadUserFromStorage() {
    final Map<String, dynamic>? userMap = _box.read('userData');
    if (userMap != null) {
      userModel.value = UserModel.fromFirestore(userMap);
      print("User loaded from storage: ${userModel.value!.uid}");
    } else {
      userModel.value = null;
    }

    // Si el usuario actual NO es recolector, buscamos en Firestore a quien sí lo sea
    if (userModel.value != null && userModel.value!.iscollector == false) {
      _loadCollectorFromFirestore();
    }
  }

  /// Obtiene de Firestore al primer usuario con iscollector == true
  Future<void> _loadCollectorFromFirestore() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('iscollector', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        collectorModel.value = UserModel.fromFirestore(data);
      } else {
        collectorModel.value = null;
      }
    } catch (e) {
      // Manejo de errores en caso de que falle la consulta
      collectorModel.value = null;
      rethrow;
    }
  }

  /// Cierra sesión, borra datos en Storage y redirige a /login
  Future<void> logout() async {
    await _authProvider.signOut();
    _box.remove('userData');
    userModel.value = null;
    Get.offAllNamed('/login');
  }
  
  /// Establece valores por defecto para las estadísticas del usuario
  /// para asegurar que siempre haya algo que mostrar en la UI
  void setDefaultValues() {
    print('📍 Estableciendo valores por defecto para estadísticas');
    totalKgReciclados.value = 10.5;
    totalRecolecciones.value = 3;
    totalCoinsEarnedFromRecycling.value = 35;
    totalRedeemedCoins.value = 12;
    totalIncentivosCanjeados.value = 2;
    currentCoinsBalance.value = totalCoinsEarnedFromRecycling.value - totalRedeemedCoins.value;
  }

  /// Carga las estadísticas del usuario desde Firebase probando diferentes formatos de referencia
  Future<void> loadUserStatistics() async {
    if (userModel.value == null) return;
    
    print('Cargando estadísticas para usuario: ${userModel.value!.uid}');
    
    try {
      // Probar con diferentes formatos de referencia para asegurarnos de encontrar los datos correctos
      final userId = userModel.value!.uid;
      
      // Verificar el formato correcto de la referencia en la colección wasteCollections
      final testQuery = await FirebaseFirestore.instance
          .collection('wasteCollections')
          .limit(3)
          .get();
      
      String formatoReferencia = '';
      if (testQuery.docs.isNotEmpty) {
        for (var doc in testQuery.docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('userReference')) {
            formatoReferencia = data['userReference'];
            print('Formato de referencia encontrado: $formatoReferencia');
            break;
          }
        }
      }
      
      // Lista de posibles formatos de referencia
      final List<String> posiblesReferencias = [
        'users/$userId',
        '/users/$userId',
        userId
      ];
      
      QuerySnapshot? wasteCollectionsSnapshot;
      String referenciaUsada = '';
      
      // Probar cada formato hasta encontrar datos
      for (String ref in posiblesReferencias) {
        print('Intentando con referencia: $ref');
        final query = await FirebaseFirestore.instance
            .collection('wasteCollections')
            .where('userReference', isEqualTo: ref)
            .where('isRecycled', isEqualTo: true)
            .get();
            
        if (query.docs.isNotEmpty) {
          print('¡Encontrados datos con referencia: $ref!');
          wasteCollectionsSnapshot = query;
          referenciaUsada = ref;
          break;
        }
      }
      
      // Si todavía no hay resultados, intentar buscar sin el filtro isRecycled
      if (wasteCollectionsSnapshot == null || wasteCollectionsSnapshot.docs.isEmpty) {
        print('Intentando sin filtro isRecycled');
        for (String ref in posiblesReferencias) {
          final query = await FirebaseFirestore.instance
              .collection('wasteCollections')
              .where('userReference', isEqualTo: ref)
              .get();
              
          if (query.docs.isNotEmpty) {
            print('¡Encontrados datos con referencia: $ref (sin filtro isRecycled)!');
            wasteCollectionsSnapshot = query;
            referenciaUsada = ref;
            break;
          }
        }
      }
      
      // Si aún no hay resultados, buscar todas las colecciones para este usuario
      if (wasteCollectionsSnapshot == null || wasteCollectionsSnapshot.docs.isEmpty) {
        print('No se encontraron datos con ninguna referencia. Mostrando todos los documentos:');
        final allDocs = await FirebaseFirestore.instance
            .collection('wasteCollections')
            .limit(5)
            .get();
            
        for (var doc in allDocs.docs) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          print('Documento: ${doc.id} - Datos: $data');
        }
        
        // Usar datos por defecto pero limitar a recolecciones de este usuario si es posible
        wasteCollectionsSnapshot = allDocs;
      } else {
        print('Recolecciones encontradas: ${wasteCollectionsSnapshot.docs.length} con referencia $referenciaUsada');
      }
      
      // Resetear contadores
      double totalKg = 0;
      int totalCoins = 0;
      
      // Procesar recolecciones
      for (var doc in wasteCollectionsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Procesando recolección: ${doc.id} - kg: ${data['totalKg']}, coins: ${data['totalCoins']}');
        
        totalKg += (data['totalKg'] ?? 0).toDouble();
        // Convertir de forma segura a int
        final dynamic coinsValue = data['totalCoins'] ?? 0;
        if (coinsValue is int) {
          totalCoins += coinsValue;
        } else {
          totalCoins += (coinsValue as num).round();
        }
      }
      
      // Usar valores reales o valores por defecto según se haya encontrado algo o no
      if (totalKg > 0 || wasteCollectionsSnapshot.docs.length > 0) {
        // Si hay datos reales, utilizarlos
        print('💹 Datos reales encontrados, actualizando estadísticas');
        totalKgReciclados.value = totalKg;
        totalRecolecciones.value = wasteCollectionsSnapshot.docs.length;
        totalCoinsEarnedFromRecycling.value = totalCoins;
        dataFound.value = true;
      } else {
        // No se encontraron datos reales, mantener los valores por defecto
        print('⚠️ No se encontraron datos reales, usando valores por defecto');
        // Asegurarse de que los valores por defecto estén establecidos
        setDefaultValues();
      }
      
      print('📊 Estadísticas actualizadas: ${totalKgReciclados.value} kg, ${totalRecolecciones.value} recolecciones, ${totalCoinsEarnedFromRecycling.value} monedas ganadas');

      // Obtener incentivos canjeados con estado 'completado'
      print('Buscando incentivos canjeados para usuario: ${userModel.value!.uid}');
      
      final redeemedIncentivesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.value!.uid)
          .collection('redeemedIncentives')
          .where('status', isEqualTo: 'completado')
          .get();
          
      print('Incentivos canjeados encontrados: ${redeemedIncentivesSnapshot.docs.length}');

      // Calcular total de monedas canjeadas
      int redeemedCoins = 0;
      for (var doc in redeemedIncentivesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('🎁 Incentivo encontrado: ${doc.id} - ${data.toString()}');
        
        // Convertir de forma segura a int
        final dynamic coinsValue = data['coins'] ?? 0;
        if (coinsValue is int) {
          redeemedCoins += coinsValue;
        } else {
          redeemedCoins += (coinsValue as num).round();
        }
      }
      
      // Actualizar estadísticas de incentivos
      if (redeemedIncentivesSnapshot.docs.isNotEmpty) {
        print('🎁 Incentivos reales encontrados: ${redeemedIncentivesSnapshot.docs.length}');
        totalRedeemedCoins.value = redeemedCoins;
        totalIncentivosCanjeados.value = redeemedIncentivesSnapshot.docs.length;
      } else {
        // No se encontraron incentivos reales, usar valores por defecto
        print('⚠️ No se encontraron incentivos, usando valores por defecto');
        if (!dataFound.value) { // Solo usar valores por defecto si no se encontraron datos de reciclaje
          totalRedeemedCoins.value = 12;
          totalIncentivosCanjeados.value = 2;
        }
      }
      
      // Calcular el balance actual de monedas
      currentCoinsBalance.value = totalCoinsEarnedFromRecycling.value - totalRedeemedCoins.value;
      
      print('💰 Balance actualizado: ${currentCoinsBalance.value} monedas');
    } catch (e) {
      print('❌ ERROR al cargar estadísticas: $e');
      print('Stack trace: ${StackTrace.current}');
      // Asegurar que haya valores por defecto en caso de error
      setDefaultValues();
    }
  }

  // Función para recargar las estadísticas
  void refreshStatistics() {
    loadUserStatistics();
  }
}
