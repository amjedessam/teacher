class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // quiz_completed, low_performance, new_student, system
  final bool isRead;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.timestamp,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id']?.toString() ?? ''),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['isRead'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  /// من صف جدول notifications في Supabase.
  factory NotificationModel.fromNotificationRow(Map<String, dynamic> row) {
    return NotificationModel(
      id: (row['id']?.toString() ?? ''),
      title: (row['title']?.toString() ?? ''),
      message: (row['message']?.toString() ?? ''),
      type: (row['notification_type']?.toString() ?? 'system'),
      isRead: row['is_read'] == true,
      timestamp: row['created_at'] != null
          ? (DateTime.tryParse(row['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
      data: row['metadata'] != null
          ? Map<String, dynamic>.from(row['metadata'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? timestamp,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }
}
