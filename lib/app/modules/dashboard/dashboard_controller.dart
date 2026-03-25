import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/auth_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/models/teacher_model.dart';
import '../../data/models/notification_model.dart';

// ── Models ───────────────────────────────────────────────────

class RecentExam {
  final int examId;
  final String title;
  final String subjectName;
  final DateTime createdAt;
  final int totalAssigned;
  final int totalCompleted;
  final double? avgScore;

  RecentExam({
    required this.examId,
    required this.title,
    required this.subjectName,
    required this.createdAt,
    required this.totalAssigned,
    required this.totalCompleted,
    this.avgScore,
  });

  double get completionRate =>
      totalAssigned == 0 ? 0 : totalCompleted / totalAssigned * 100;

  factory RecentExam.fromJson(Map<String, dynamic> json) => RecentExam(
    examId: (json['exam_id'] as num).toInt(),
    title: json['title']?.toString() ?? '',
    subjectName: json['subject_name']?.toString() ?? '',
    createdAt:
        DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    totalAssigned: (json['total_assigned'] as num?)?.toInt() ?? 0,
    totalCompleted: (json['total_completed'] as num?)?.toInt() ?? 0,
    avgScore: json['avg_score'] != null
        ? (json['avg_score'] as num).toDouble()
        : null,
  );
}

class LowPerformer {
  final int studentId;
  final String studentName;
  final String examTitle;
  final String subjectName;
  final double percentage;
  final int sectionId;
  final String className;

  LowPerformer({
    required this.studentId,
    required this.studentName,
    required this.examTitle,
    required this.subjectName,
    required this.percentage,
    required this.sectionId,
    required this.className,
  });

  factory LowPerformer.fromJson(Map<String, dynamic> json) => LowPerformer(
    studentId: (json['student_id'] as num?)?.toInt() ?? 0,
    studentName: json['student_name']?.toString() ?? '',
    examTitle: json['exam_title']?.toString() ?? '',
    subjectName: json['subject_name']?.toString() ?? '',
    percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    sectionId: (json['section_id'] as num?)?.toInt() ?? 0,
    className: json['class_name']?.toString() ?? '',
  );
}

// ── Controller ───────────────────────────────────────────────

class DashboardController extends GetxController {
  final AuthService _authService = Get.find();
  final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
  final NotificationsRepository _notificationsRepo =
      Get.find<NotificationsRepository>();
  SupabaseClient get _client => Supabase.instance.client;

  final isLoading = true.obs;
  final teacher = Rxn<TeacherModel>();
  final notifications = <NotificationModel>[].obs;
  final unreadNotificationsCount = 0.obs;

  // ── إحصائيات حقيقية ──────────────────────────────────────
  final totalStudents = 0.obs;
  final totalClasses = 0.obs;
  final avgScore = 0.0.obs;
  final totalExams = 0.obs;
  final recentExams = <RecentExam>[].obs;
  final lowPerformers = <LowPerformer>[].obs;

  int get _teacherId => int.parse(_authService.currentUser.value!.id);

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      teacher.value = _authService.currentUser.value;

      // جلب الفصول والطلاب
      final classes = await _classesRepo.getAssignedClasses();
      totalClasses.value = classes.length;
      totalStudents.value = classes.fold<int>(
        0,
        (sum, c) => sum + c.totalStudents,
      );

      // جلب إحصائيات Dashboard من RPC
      await _loadDashboardStats();

      // الإشعارات
      notifications.value = await _notificationsRepo.getNotifications();
      _updateUnreadCount();
    } catch (e) {
      debugPrint('loadDashboardData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDashboardStats() async {
    try {
      final res = await _client.rpc(
        'get_teacher_dashboard_stats',
        params: {'p_teacher_id': _teacherId},
      );
      if (res == null) return;

      final data = Map<String, dynamic>.from(res);

      avgScore.value = (data['avg_score'] as num?)?.toDouble() ?? 0;
      totalExams.value = (data['total_exams'] as num?)?.toInt() ?? 0;

      final recentList = data['recent_exams'] as List? ?? [];
      recentExams.value = recentList
          .map((e) => RecentExam.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      final lowList = data['low_performers'] as List? ?? [];
      lowPerformers.value = lowList
          .map((e) => LowPerformer.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('_loadDashboardStats error: $e');
    }
  }

  void _updateUnreadCount() {
    unreadNotificationsCount.value = notifications
        .where((n) => !n.isRead)
        .length;
  }

  Future<void> refreshData() async => loadDashboardData();
}
