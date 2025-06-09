import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recicla_tarapoto_1/app/controllers/notification_controller.dart';

class NotificationsDialog extends StatelessWidget {
  NotificationsDialog({super.key});

  static const Color primaryGreen = Color(0xFF16A34A);
  final NotificationController controller = Get.put(NotificationController());

  IconData _getIconForType(String type) {
    switch (type) {
      case 'monedas':
        return Icons.monetization_on_outlined;
      case 'incentivo':
        return Icons.star_outline;
      case 'actualizacion':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'monedas':
        return primaryGreen;
      case 'incentivo':
        return Colors.blueAccent;
      case 'actualizacion':
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black54, size: 28),
                onPressed: () {
                  Get.back();
                  Get.delete<NotificationController>(); 
                }
              ),
            ),
            const Text(
              "Notificaciones",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Obx(() { 
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: primaryGreen));
              }
              if (controller.notifications.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      "No tienes notificaciones nuevas.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.separated(
                  shrinkWrap: true, 
                  itemCount: controller.notifications.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return _buildNotificationCard(
                      context,
                      icon: _getIconForType(notification.type),
                      color: _getColorForType(notification.type),
                      title: notification.title,
                      date: controller.formatDate(notification.date),
                      description: notification.description,
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String date,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: Colors.black.withOpacity(0.75),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
