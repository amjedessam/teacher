import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher/app/data/services/auth_service.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../data/models/student_model.dart';

class StudentExamResult {
  final int examId;
  final String title;
  final String subjectName;
  final double obtainedMarks;
  final double totalMarks;
  final double percentage;
  final String status;
  final DateTime? submittedAt;
  final String assignmentType; // 'class' | 'individual'

  StudentExamResult({
    required this.examId,
    required this.title,
    required this.subjectName,
    required this.obtainedMarks,
    required this.totalMarks,
    required this.percentage,
    required this.status,
    this.submittedAt,
    required this.assignmentType,
  });

  bool get isClassExam => assignmentType == 'class';

  factory StudentExamResult.fromJson(Map<String, dynamic> json) {
    return StudentExamResult(
      examId: json['exam_id'] as int,
      title: json['title']?.toString() ?? '',
      subjectName: json['subject_name']?.toString() ?? '',
      obtainedMarks: (json['obtained_marks'] as num?)?.toDouble() ?? 0,
      totalMarks: (json['total_marks'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString())
          : null,
      assignmentType: json['assignment_type']?.toString() ?? 'individual',
    );
  }
}

// ── نموذج أداء المادة في الاختبارات الرسمية ─────────────────
class FormalSubjectPerformance {
  final String subjectName;
  final int subjectId;
  final int totalExams;
  final int passed;
  final double avgScore;
  final double highest;
  final double lowest;

  FormalSubjectPerformance({
    required this.subjectName,
    required this.subjectId,
    required this.totalExams,
    required this.passed,
    required this.avgScore,
    required this.highest,
    required this.lowest,
  });

  int get failed => totalExams - passed;
  double get passRate => totalExams == 0 ? 0 : passed / totalExams * 100;

  factory FormalSubjectPerformance.fromJson(Map<String, dynamic> json) =>
      FormalSubjectPerformance(
        subjectName: json['subject_name']?.toString() ?? '',
        subjectId: (json['subject_id'] as num?)?.toInt() ?? 0,
        totalExams: (json['total_exams'] as num?)?.toInt() ?? 0,
        passed: (json['passed'] as num?)?.toInt() ?? 0,
        avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
        highest: (json['highest'] as num?)?.toDouble() ?? 0,
        lowest: (json['lowest'] as num?)?.toDouble() ?? 0,
      );
}

// ── نموذج أداء المادة في التدريب الذاتي ─────────────────────
class PracticeSubjectPerformance {
  final String subjectName;
  final int totalQuizzes;
  final double avgScore;
  final DateTime? lastQuizDate;

  PracticeSubjectPerformance({
    required this.subjectName,
    required this.totalQuizzes,
    required this.avgScore,
    this.lastQuizDate,
  });

  factory PracticeSubjectPerformance.fromJson(Map<String, dynamic> json) =>
      PracticeSubjectPerformance(
        subjectName: json['subject_name']?.toString() ?? '',
        totalQuizzes: (json['total_quizzes'] as num?)?.toInt() ?? 0,
        avgScore: (json['avg_score'] as num?)?.toDouble() ?? 0,
        lastQuizDate: json['last_quiz_date'] != null
            ? DateTime.tryParse(json['last_quiz_date'].toString())
            : null,
      );
}

// ── ملخص الأداء الكامل ───────────────────────────────────────
class StudentPerformanceSummary {
  // الاختبارات الرسمية
  final int formalTotal;
  final int formalPassed;
  final int formalFailed;
  final double formalAvg;
  final double formalHighest;
  final double formalLowest;
  final List<FormalSubjectPerformance> formalBySubject;
  // التدريب الذاتي
  final int practiceTotal;
  final double practiceAvg;
  final List<PracticeSubjectPerformance> practiceBySubject;

  StudentPerformanceSummary({
    required this.formalTotal,
    required this.formalPassed,
    required this.formalFailed,
    required this.formalAvg,
    required this.formalHighest,
    required this.formalLowest,
    required this.formalBySubject,
    required this.practiceTotal,
    required this.practiceAvg,
    required this.practiceBySubject,
  });

  factory StudentPerformanceSummary.fromJson(Map<String, dynamic> json) {
    final formalExams = json['formal_exams'] as Map? ?? {};
    final practiceStats = json['practice_stats'] as Map? ?? {};

    final formalList = json['formal_by_subject'] as List? ?? [];
    final practiceList = json['practice_by_subject'] as List? ?? [];

    return StudentPerformanceSummary(
      formalTotal: (formalExams['total'] as num?)?.toInt() ?? 0,
      formalPassed: (formalExams['passed'] as num?)?.toInt() ?? 0,
      formalFailed: (formalExams['failed'] as num?)?.toInt() ?? 0,
      formalAvg: (formalExams['avg_score'] as num?)?.toDouble() ?? 0,
      formalHighest: (formalExams['highest'] as num?)?.toDouble() ?? 0,
      formalLowest: (formalExams['lowest'] as num?)?.toDouble() ?? 0,
      formalBySubject: formalList
          .map(
            (e) =>
                FormalSubjectPerformance.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      practiceTotal: (practiceStats['total_quizzes'] as num?)?.toInt() ?? 0,
      practiceAvg: (practiceStats['avg_score'] as num?)?.toDouble() ?? 0,
      practiceBySubject: practiceList
          .map(
            (e) => PracticeSubjectPerformance.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }
}

class StudentDetailController extends GetxController {
  SupabaseClient get _client => Supabase.instance.client;

  final student = Rxn<StudentModel>();
  final selectedTabIndex = 0.obs;
  final isLoadingStats = false.obs;

  // إحصائيات الحضور
  final totalDays = 0.obs;
  final presentDays = 0.obs;
  final absentDays = 0.obs;
  final lateDays = 0.obs;

  // إحصائيات الامتحانات
  final averageScore = 0.0.obs;
  final totalExams = 0.obs;
  final completedExams = 0.obs;
  final subjectPerformanceList = <SubjectPerformance>[].obs;
  final recentResults = <Map<String, dynamic>>[].obs;

  // ── نتائج الاختبارات الرسمية ──────────────────────────────────────────────
  final examResults = <StudentExamResult>[].obs;
  final isLoadingExams = false.obs;

  // ── ملخص الأداء الشامل ────────────────────────────────────────────────────
  final performanceSummary = Rxn<StudentPerformanceSummary>();
  final isLoadingPerformance = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['student'] != null) {
      student.value = arguments['student'] as StudentModel;
      _loadStudentStats();
      _loadPerformanceSummary();
    }

    // جلب البيانات عند تغيير التاب
    ever(selectedTabIndex, (index) {
      if (index == 0 && performanceSummary.value == null) {
        _loadPerformanceSummary();
      }
      if (index == 1 && examResults.isEmpty) {
        _loadExamResults();
      }
    });
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> _loadStudentStats() async {
    if (student.value == null) return;
    isLoadingStats.value = true;
    try {
      final studentId = int.tryParse(student.value!.id);
      if (studentId == null) return;

      final res = await _client.rpc(
        'get_student_stats_for_teacher',
        params: {'p_student_id': studentId},
      );

      if (res == null) return;

      final data = res is Map ? res : {};
      final practiceStats = data['practice_stats'] as Map? ?? {};
      final attStats = data['attendance_stats'] as Map? ?? {};
      final subjects = data['subject_performance'] as List? ?? [];

      // ── الحضور فقط من هذه الـ RPC ──────────────────
      // averageScore و totalExams تأتي من performanceSummary (الاختبارات الرسمية)
      totalExams.value = 0;
      completedExams.value = 0;
      averageScore.value = 0.0;

      totalDays.value = attStats['total_days'] ?? 0;
      presentDays.value = attStats['present_days'] ?? 0;
      absentDays.value = attStats['absent_days'] ?? 0;
      lateDays.value = attStats['late_days'] ?? 0;

      subjectPerformanceList.value = subjects.map((e) {
        final score = (e['average_score'] ?? 0.0).toDouble();
        return SubjectPerformance(
          subjectName: e['subject_name']?.toString() ?? '',
          score: score,
          trend: score >= 70
              ? 'up'
              : score >= 50
              ? 'stable'
              : 'down',
        );
      }).toList();

      // سيتم تحديث student.value بعد تحميل performanceSummary
    } catch (e, stack) {
      debugPrint('StudentDetail ERROR: $e');
      debugPrint('STACK: $stack');
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> _loadPerformanceSummary() async {
    final studentId = int.tryParse(student.value?.id ?? '');
    if (studentId == null) return;
    isLoadingPerformance.value = true;
    try {
      final res = await _client.rpc(
        'get_student_performance_summary',
        params: {'p_student_id': studentId, 'p_teacher_id': _teacherId},
      );
      if (res != null) {
        final summary = StudentPerformanceSummary.fromJson(
          Map<String, dynamic>.from(res),
        );
        performanceSummary.value = summary;

        // ✅ تحديث البطاقات الرئيسية بالاختبارات الرسمية
        averageScore.value = summary.formalAvg;
        totalExams.value = summary.formalTotal;
        completedExams.value = summary.formalTotal;

        // تحديث StudentModel بالبيانات الرسمية
        if (student.value != null) {
          student.value = StudentModel(
            id: student.value!.id,
            name: student.value!.name,
            email: student.value!.email,
            studentCode: student.value!.studentCode,
            classId: student.value!.classId,
            className: student.value!.className,
            profileImage: student.value!.profileImage,
            averageScore: summary.formalAvg,
            totalQuizzes: summary.formalTotal,
            completedQuizzes: summary.formalPassed,
            masteryLevel: _getMasteryLevel(summary.formalAvg),
            subjectPerformance: summary.formalBySubject
                .map(
                  (s) => SubjectPerformance(
                    subjectName: s.subjectName,
                    score: s.avgScore,
                    trend: s.avgScore >= 70
                        ? 'up'
                        : s.avgScore >= 50
                        ? 'stable'
                        : 'down',
                  ),
                )
                .toList(),
            lastActive: student.value!.lastActive,
          );
        }
      }
    } catch (e) {
      debugPrint('_loadPerformanceSummary error: \$e');
    } finally {
      isLoadingPerformance.value = false;
    }
  }

  Future<void> _loadExamResults() async {
    final studentId = int.tryParse(student.value?.id ?? '');
    if (studentId == null) return;

    isLoadingExams.value = true;
    try {
      final res = await _client.rpc(
        'get_student_exam_results',
        params: {'p_student_id': studentId},
      );

      if (res == null) {
        examResults.value = [];
        return;
      }

      final list = res as List;
      examResults.value = list
          .map(
            (e) =>
                StudentExamResult.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } catch (e) {
      debugPrint('_loadExamResults error: $e');
    } finally {
      isLoadingExams.value = false;
    }
  }

  String _getMasteryLevel(double avg) {
    if (avg >= 85) return 'Mastered';
    if (avg >= 70) return 'Proficient';
    if (avg >= 50) return 'Developing';
    return 'Needs Improvement';
  }

  double get attendancePercentage {
    if (totalDays.value == 0) return 0;
    return (presentDays.value / totalDays.value) * 100;
  }

  void sendMessage() {
    Get.toNamed(AppRoutes.quizBuilder, arguments: {'student': student.value});
  }

  int get _teacherId =>
      int.parse(Get.find<AuthService>().currentUser.value!.id);
}
