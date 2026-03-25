import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification_model.dart';

/// جلب وتحديث إشعارات المعلم من Supabase (RLS: recipient_teacher_id = JWT).
class NotificationsRepository {
  SupabaseClient get _client => Supabase.instance.client;

  /// RLS يقتصر النتائج على إشعارات المعلم الحالي (recipient_teacher_id = effective_app_user_id).
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final res = await _client
          .from('notifications')
          .select('id, title, message, notification_type, is_read, created_at, metadata')
          .order('created_at', ascending: false);
      if (res == null) return [];
      final list = res is List ? res : [res];
      return list
          .map<NotificationModel>((e) =>
              NotificationModel.fromNotificationRow(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// RLS يسمح بالتحديث فقط لصفوف المعلم الحالي.
  Future<bool> markAsRead(String notificationId) async {
    try {
      final id = int.tryParse(notificationId);
      if (id == null) return false;
      await _client.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// تحديث كل الإشعارات غير المقروءة للمعلم الحالي (RLS يطبّق على الصفوف).
  Future<bool> markAllAsRead() async {
    try {
      await _client.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('is_read', false);
      return true;
    } catch (_) {
      return false;
    }
  }
}
