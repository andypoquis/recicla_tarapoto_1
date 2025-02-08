// lib/app/controllers/homecollector_controller.dart
import 'package:get/get.dart';

import '../data/models/waste_collection.dart';
import '../data/provider/wasteCollectionsProvider.dart';

class HomecollectorController extends GetxController {
  final WasteCollectionsProvider _provider = WasteCollectionsProvider();
  late Stream<List<WasteCollectionModel>> wasteCollectionsStream;

  @override
  void onInit() {
    super.onInit();
    wasteCollectionsStream = _provider.getPendingWasteCollections();
  }

  Future<void> markAsRecycled(WasteCollectionModel waste) async {
    final updated = waste.copyWith(isRecycled: true);
    await _provider.updateWasteCollection(waste.id, updated);
  }

  /// Si también deseas actualizar `residues` con los nuevos valores
  Future<void> updateResidues(WasteCollectionModel waste) async {
    await _provider.updateWasteCollection(waste.id, waste);
  }
}
