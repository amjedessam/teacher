import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/notification_model.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('الإشعارات', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(
            () => controller.unreadCount.value > 0
                ? TextButton(
                    onPressed: controller.markAllAsRead,
                    child: const Text('تحديد الكل كمقروء'),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationCard(notification);
          },
        );
      }),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? AppColors.border
              : AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () => controller.markAsRead(notification),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationColor(
                    notification.type,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(notification.message, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'quiz_completed':
        return Icons.check_circle_outline;
      case 'low_performance':
        return Icons.warning_amber_outlined;
      case 'new_student':
        return Icons.person_add_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'quiz_completed':
        return AppColors.success;
      case 'low_performance':
        return AppColors.warning;
      case 'new_student':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('لا توجد إشعارات', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'ستظهر الإشعارات الجديدة هنا',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
