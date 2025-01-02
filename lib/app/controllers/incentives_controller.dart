// lib/app/controllers/incentives_controller.dart
import 'package:get/get.dart';

import '../data/models/incentive.dart';
import '../data/provider/incentives_provider.dart';

class IncentivesController extends GetxController {
  final IncentivesProvider _provider = IncentivesProvider();

  /// Lista observable de [Incentive] que se actualizará en tiempo real.
  RxList<Incentive> incentivesList = <Incentive>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initIncentivesListener();
  }

  /// Se suscribe a los cambios de la colección `incentives` en Firestore.
  void _initIncentivesListener() {
    _provider.getIncentives().listen((incentives) {
      incentivesList.value = incentives;
    });
  }

  /// Puedes añadir métodos para agregar, actualizar o eliminar incentivos
  /// utilizando los métodos del provider.
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
