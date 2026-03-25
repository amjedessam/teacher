import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/auth_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/models/class_model.dart';

// ── Models ───────────────────────────────────────────────────

class ClassReportStudent {
  final int studentId;
  final String studentName;
  final String studentCode;
  final String? profileImage;
  final double avgScore;
  final int totalExams;
  final int passed;

  ClassReportStudent({
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    this.profileImage,
    required this.avgScore,
    required this.totalExams,
    required this.passed,
  });

  int get failed => totalExams - passed;

  factory ClassReportStudent.fromJson(Map<String, dynamic> json) =>
      ClassReportStudent(
        studentId: (json['student_id'] as num).toInt(),
        studentName: json['student_name']?.toString() ?? '',
        studentCode: json['student_code']?.toString() ?? '',
        profileImage: json['profile_image']?.toString(),
        avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
        totalExams: (json['total_exams'] as num?)?.toInt() ?? 0,
        passed: (json['passed'] as num?)?.toInt() ?? 0,
      );
}

class ClassReportSummary {
  final int totalStudents;
  final double avgScore;
  final int passedCount;
  final int failedCount;
  final int excellentCount;
  final int goodCount;
  final int averageCount;
  final int weakCount;

  ClassReportSummary({
    required this.totalStudents,
    required this.avgScore,
    required this.passedCount,
    required this.failedCount,
    required this.excellentCount,
    required this.goodCount,
    required this.averageCount,
    required this.weakCount,
  });

  factory ClassReportSummary.fromJson(Map<String, dynamic> json) =>
      ClassReportSummary(
        totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
        avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
        passedCount: (json['passed_count'] as num?)?.toInt() ?? 0,
        failedCount: (json['failed_count'] as num?)?.toInt() ?? 0,
        excellentCount: (json['excellent_count'] as num?)?.toInt() ?? 0,
        goodCount: (json['good_count'] as num?)?.toInt() ?? 0,
        averageCount: (json['average_count'] as num?)?.toInt() ?? 0,
        weakCount: (json['weak_count'] as num?)?.toInt() ?? 0,
      );
}

// ── Controller ───────────────────────────────────────────────

class ClassReportController extends GetxController {
  final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
  final AuthService _authService = Get.find<AuthService>();
  SupabaseClient get _client => Supabase.instance.client;

  final classes = <ClassModel>[].obs;
  final selectedClassId = Rxn<String>();
  final isLoading = true.obs;

  final summary = Rxn<ClassReportSummary>();
  final students = <ClassReportStudent>[].obs;

  int get _teacherId => int.parse(_authService.currentUser.value!.id);

  // ── getters للـ View ──────────────────────────────────────
  double get classAverage => summary.value?.avgScore ?? 0;
  int get excellentCount => summary.value?.excellentCount ?? 0;
  int get goodCount => summary.value?.goodCount ?? 0;
  int get averageCount => summary.value?.averageCount ?? 0;
  int get weakCount => summary.value?.weakCount ?? 0;

  List<ClassReportStudent> get topStudents {
    final sorted = List<ClassReportStudent>.from(students);
    sorted.sort((a, b) => b.avgScore.compareTo(a.avgScore));
    return sorted.take(5).toList();
  }

  List<ClassReportStudent> get strugglingStudents =>
      students.where((s) => s.avgScore < 60).toList();

  ClassModel? get selectedClass =>
      classes.firstWhereOrNull((c) => c.id == selectedClassId.value);

  @override
  void onInit() {
    super.onInit();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final loaded = await _classesRepo.getAssignedClasses();
      classes.value = loaded;
      if (loaded.isNotEmpty) {
        selectedClassId.value = loaded.first.id;
        await _loadReport();
      }
    } catch (e) {
      debugPrint('_loadClasses error: $e');
    }
  }

  Future<void> _loadReport() async {
    if (selectedClassId.value == null) return;

    // استخراج sectionId من classId (تنسيق: "sectionId_subjectId")
    final sectionId =
        int.tryParse(selectedClassId.value!.split('_').first) ?? 0;
    if (sectionId <= 0) return;

    isLoading.value = true;
    try {
      final res = await _client.rpc(
        'get_class_report',
        params: {'p_section_id': sectionId, 'p_teacher_id': _teacherId},
      );

      if (res == null) return;
      final data = Map<String, dynamic>.from(res);

      summary.value = ClassReportSummary.fromJson(
        Map<String, dynamic>.from(data['summary']),
      );

      final studentsList = data['students'] as List? ?? [];
      students.value = studentsList
          .map((e) => ClassReportStudent.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      debugPrint('_loadReport error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeClass(String? classId) {
    if (classId != null) {
      selectedClassId.value = classId;
      _loadReport();
    }
  }

  // للتوافق مع الـ View القديم
  Future<void> loadStudents() async => _loadReport();
}
