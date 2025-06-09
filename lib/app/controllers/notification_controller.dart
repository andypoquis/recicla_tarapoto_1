import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:recicla_tarapoto_1/app/controllers/user_controller.dart';

class AppNotification {
  final String type;
  final String title;
  final DateTime date;
  final String description;
  final String? originalId;

  AppNotification({
    required this.type,
    required this.title,
    required this.date,
    required this.description,
    this.originalId,
  });
}

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController _userController = Get.find<UserController>();

  RxBool isLoading = true.obs;
  RxList<AppNotification> notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      notifications.clear();

      final String? uid = _userController.userModel.value?.uid;
      if (uid == null) {
        print("NotificationController: User UID is null. Cannot fetch user-specific notifications.");
        isLoading.value = false;
        return;
      }
      print("NotificationController: Fetching notifications for UID: $uid");

      List<AppNotification> fetchedNotifications = [];

      // 1. Fetch "Monedas" notifications
      try {
        final wasteCollectionsSnap = await _firestore
            .collection('wasteCollections')
            .where('userReference', isEqualTo: _firestore.doc('users/$uid'))
            .where('isRecycled', isEqualTo: true)
            // .orderBy('date', descending: true) // Firestore might require an index for this
            .get();
        print("NotificationController: Fetched ${wasteCollectionsSnap.docs.length} wasteCollections docs.");

        for (var doc in wasteCollectionsSnap.docs) {
          final data = doc.data();
          fetchedNotifications.add(AppNotification(
            type: 'monedas',
            title: 'Monedas Recibidas',
            date: (data['date'] as Timestamp).toDate(),
            description: 'Recibiste un total de ${data['totalCoins']} monedas por tu entrega de residuos.',
            originalId: doc.id,
          ));
        }
      } catch (e) {
        print("Error fetching 'Monedas' notifications: $e");
      }

      // 2. Fetch "Incentivo" notifications
      try {
        final redeemedIncentivesSnap = await _firestore
            .collection('users')
            .doc(uid)
            .collection('redeemedIncentives')
            .where('status', isEqualTo: 'completado')
            // .orderBy('createdAt', descending: true) // Firestore might require an index
            .get();
        print("NotificationController: Fetched ${redeemedIncentivesSnap.docs.length} redeemedIncentives docs.");

        for (var doc in redeemedIncentivesSnap.docs) {
          final data = doc.data();
          fetchedNotifications.add(AppNotification(
            type: 'incentivo',
            title: 'Incentivo Canjeado',
            date: (data['createdAt'] as Timestamp).toDate(),
            description: 'Canjeaste el incentivo "${data['name']}" por ${data['redeemedCoins']} monedas.',
            originalId: doc.id,
          ));
        }
      } catch (e) {
        print("Error fetching 'Incentivo' notifications: $e");
      }

      // 3. Fetch "Actualización" notifications
      try {
        final announcementsSnap = await _firestore
            .collection('announcements')
            // .orderBy('createdAt', descending: true) // Firestore might require an index
            .get();
        print("NotificationController: Fetched ${announcementsSnap.docs.length} announcements docs.");

        for (var doc in announcementsSnap.docs) {
          final data = doc.data();
          fetchedNotifications.add(AppNotification(
            type: 'actualizacion',
            title: data['title'] ?? 'Actualización Importante',
            date: (data['createdAt'] as Timestamp).toDate(),
            description: data['content'] ?? 'No hay contenido.',
            originalId: doc.id,
          ));
        }
      } catch (e) {
        print("Error fetching 'Actualización' notifications: $e");
      }
      
      // Sort all notifications by date after all fetches are complete
      fetchedNotifications.sort((a, b) => b.date.compareTo(a.date));
      notifications.assignAll(fetchedNotifications);
      print("NotificationController: Total notifications processed: ${notifications.length}");

    } catch (e) {
      print("Error in fetchNotifications main try-catch: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
    } catch (e) {
      print("Error formatting date: $e");
      return date.toIso8601String(); // Fallback
    }
  }
}
