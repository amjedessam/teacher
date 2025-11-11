// notifications_controller.dart
import 'package:get/get.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final mockDataService = MockDataService();

  final isLoading = true.obs;
  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    notifications.value = mockDataService.getNotifications();
    _updateUnreadCount();

    isLoading.value = false;
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  void markAsRead(NotificationModel notification) {
    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      notifications[index] = notification.copyWith(isRead: true);
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    notifications.value = notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    _updateUnreadCount();
  }
}
