import 'package:get/get.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final NotificationsRepository _repo = Get.find<NotificationsRepository>();

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
    try {
      notifications.value = await _repo.getNotifications();
      _updateUnreadCount();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(NotificationModel notification) async {
    final ok = await _repo.markAsRead(notification.id);
    if (ok) {
      final index = notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        notifications[index] = notification.copyWith(isRead: true);
        _updateUnreadCount();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final ok = await _repo.markAllAsRead();
    if (ok) {
      notifications.value =
          notifications.map((n) => n.copyWith(isRead: true)).toList();
      _updateUnreadCount();
    }
  }
}
