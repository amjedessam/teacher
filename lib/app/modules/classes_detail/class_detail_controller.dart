// // import 'package:get/get.dart';
// // import '../../data/models/class_model.dart';
// // import '../../data/models/student_model.dart';
// // import '../../data/repositories/classes_repository.dart';
// // import '../../routes/app_routes.dart';

// // class ClassDetailController extends GetxController {
// //   final ClassesRepository _classesRepo = Get.find<ClassesRepository>();

// //   final classItem = Rxn<ClassModel>();
// //   final students = <StudentModel>[].obs;
// //   final isLoading = true.obs;
// //   final selectedTabIndex = 0.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     final arguments = Get.arguments as Map<String, dynamic>?;
// //     if (arguments != null && arguments['class'] != null) {
// //       classItem.value = arguments['class'] as ClassModel;
// //       loadStudents();
// //     }
// //   }

// //   Future<void> loadStudents() async {
// //     isLoading.value = true;
// //     try {
// //       final c = classItem.value;
// //       if (c != null) {
// //         final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
// //         if (sectionId > 0) {
// //           students.value = await _classesRepo.getStudentsBySection(
// //             sectionId: sectionId,
// //             sectionName: c.name,
// //           );
// //         }
// //       }
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   void changeTab(int index) {
// //     selectedTabIndex.value = index;
// //   }

// //   void viewStudentDetail(StudentModel student) {
// //     Get.toNamed(AppRoutes.studentDetail, arguments: {'student': student});
// //   }

// //   // void sendMessageToClass() {
// //   //   Get.snackbar(
// //   //     'رسالة جماعية',
// //   //     'سيتم إرسال رسالة لجميع طلاب ${classItem.value?.name}',
// //   //   );
// //   // }

// //   void createQuizForClass() {
// //     Get.snackbar(
// //       'إنشاء اختبار',
// //       'سيتم إنشاء اختبار لـ ${classItem.value?.name}',
// //     );
// //   }

// //   void openAttendance() {
// //     final c = classItem.value;
// //     if (c == null || students.isEmpty) return;
// //     final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
// //     if (sectionId <= 0) return;
// //     Get.toNamed(AppRoutes.attendance, arguments: {
// //       'sectionId': sectionId,
// //       'sectionName': c.name,
// //       'students': students.toList(),
// //     });
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../data/models/class_model.dart';
// import '../../data/models/student_model.dart';
// import '../../data/repositories/classes_repository.dart';
// import '../../routes/app_routes.dart';

// class ClassExamStat {
//   final int examId;
//   final String title;
//   final int totalMarks;
//   final int passingMarks;
//   final int durationMinutes;
//   final String status;
//   final DateTime createdAt;
//   final int totalAssigned;
//   final int totalCompleted;
//   final double? averageScore;

//   ClassExamStat({
//     required this.examId,
//     required this.title,
//     required this.totalMarks,
//     required this.passingMarks,
//     required this.durationMinutes,
//     required this.status,
//     required this.createdAt,
//     required this.totalAssigned,
//     required this.totalCompleted,
//     this.averageScore,
//   });

//   factory ClassExamStat.fromJson(Map<String, dynamic> json) {
//     return ClassExamStat(
//       examId: json['exam_id'] as int,
//       title: json['title']?.toString() ?? '',
//       totalMarks: json['total_marks'] as int? ?? 0,
//       passingMarks: json['passing_marks'] as int? ?? 0,
//       durationMinutes: json['duration_minutes'] as int? ?? 30,
//       status: json['status']?.toString() ?? '',
//       createdAt: DateTime.parse(json['created_at'].toString()),
//       totalAssigned: (json['total_assigned'] as num?)?.toInt() ?? 0,
//       totalCompleted: (json['total_completed'] as num?)?.toInt() ?? 0,
//       averageScore: json['average_score'] != null
//           ? (json['average_score'] as num).toDouble()
//           : null,
//     );
//   }

//   double get completionRate =>
//       totalAssigned == 0 ? 0 : (totalCompleted / totalAssigned) * 100;
// }

// class ClassDetailController extends GetxController {
//   final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
//   SupabaseClient get _client => Supabase.instance.client;

//   final classItem = Rxn<ClassModel>();
//   final students = <StudentModel>[].obs;
//   final isLoading = true.obs;
//   final selectedTabIndex = 0.obs;

//   // ── اختبارات الفصل ────────────────────────────────────────────────────────
//   final classExams = <ClassExamStat>[].obs;
//   final isLoadingExams = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final arguments = Get.arguments as Map<String, dynamic>?;
//     if (arguments != null && arguments['class'] != null) {
//       classItem.value = arguments['class'] as ClassModel;
//       loadStudents();
//     }

//     // جلب الاختبارات عند تغيير التبويب لـ 1
//     ever(selectedTabIndex, (index) {
//       if (index == 1 && classExams.isEmpty) {
//         loadClassExams();
//       }
//     });
//   }

//   Future<void> loadStudents() async {
//     isLoading.value = true;
//     try {
//       final c = classItem.value;
//       if (c != null) {
//         final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
//         if (sectionId > 0) {
//           students.value = await _classesRepo.getStudentsBySection(
//             sectionId: sectionId,
//             sectionName: c.name,
//           );
//         }
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadClassExams() async {
//     final c = classItem.value;
//     if (c == null) return;

//     final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
//     if (sectionId <= 0) return;

//     isLoadingExams.value = true;
//     try {
//       final res = await _client.rpc(
//         'get_class_exams_with_stats',
//         params: {'p_section_id': sectionId},
//       );

//       if (res == null) {
//         classExams.value = [];
//         return;
//       }

//       final list = res as List;
//       classExams.value = list
//           .map(
//             (e) => ClassExamStat.fromJson(Map<String, dynamic>.from(e as Map)),
//           )
//           .toList();
//     } catch (e) {
//       debugPrint('loadClassExams error: $e');
//     } finally {
//       isLoadingExams.value = false;
//     }
//   }

//   void changeTab(int index) {
//     selectedTabIndex.value = index;
//   }

//   void viewStudentDetail(StudentModel student) {
//     Get.toNamed(AppRoutes.studentDetail, arguments: {'student': student});
//   }

//   void createQuizForClass() {
//     Get.toNamed(AppRoutes.quizBuilder);
//   }

//   void openAttendance() {
//     final c = classItem.value;
//     if (c == null || students.isEmpty) return;
//     final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
//     if (sectionId <= 0) return;
//     Get.toNamed(
//       AppRoutes.attendance,
//       arguments: {
//         'sectionId': sectionId,
//         'sectionName': c.name,
//         'students': students.toList(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/class_model.dart';
import '../../data/models/student_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

// ══════════════════════════════════════════════════════════════
// Models
// ══════════════════════════════════════════════════════════════

class ClassExamStat {
  final int examId;
  final String title;
  final int totalMarks;
  final int passingMarks;
  final int durationMinutes;
  final String status;
  final DateTime createdAt;
  final int totalAssigned;
  final int totalCompleted;
  final double? averageScore;

  ClassExamStat({
    required this.examId,
    required this.title,
    required this.totalMarks,
    required this.passingMarks,
    required this.durationMinutes,
    required this.status,
    required this.createdAt,
    required this.totalAssigned,
    required this.totalCompleted,
    this.averageScore,
  });

  factory ClassExamStat.fromJson(Map<String, dynamic> json) {
    return ClassExamStat(
      examId: json['exam_id'] as int,
      title: json['title']?.toString() ?? '',
      totalMarks: json['total_marks'] as int? ?? 0,
      passingMarks: json['passing_marks'] as int? ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 30,
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()),
      totalAssigned: (json['total_assigned'] as num?)?.toInt() ?? 0,
      totalCompleted: (json['total_completed'] as num?)?.toInt() ?? 0,
      averageScore: json['average_score'] != null
          ? (json['average_score'] as num).toDouble()
          : null,
    );
  }

  double get completionRate =>
      totalAssigned == 0 ? 0 : (totalCompleted / totalAssigned) * 100;
}

class WeakQuestion {
  final int questionId;
  final String questionText;
  final int totalAttempts;
  final int wrongAttempts;
  final double failRate;

  WeakQuestion({
    required this.questionId,
    required this.questionText,
    required this.totalAttempts,
    required this.wrongAttempts,
    required this.failRate,
  });

  factory WeakQuestion.fromJson(Map<String, dynamic> json) => WeakQuestion(
    questionId: (json['question_id'] as num).toInt(),
    questionText: json['question_text']?.toString() ?? '',
    totalAttempts: (json['total_attempts'] as num).toInt(),
    wrongAttempts: (json['wrong_attempts'] as num).toInt(),
    failRate: (json['fail_rate'] as num).toDouble(),
  );
}

class ExamDetailStats {
  final int totalAssigned;
  final int totalCompleted;
  final int passed;
  final int failed;
  final double? avgPercentage;
  final double? highestScore;
  final double? lowestScore;
  final List<WeakQuestion> weakQuestions;

  ExamDetailStats({
    required this.totalAssigned,
    required this.totalCompleted,
    required this.passed,
    required this.failed,
    this.avgPercentage,
    this.highestScore,
    this.lowestScore,
    required this.weakQuestions,
  });

  factory ExamDetailStats.fromJson(Map<String, dynamic> json) {
    final weakList = json['weak_questions'];
    List<WeakQuestion> weak = [];
    if (weakList is List) {
      weak = weakList
          .map((e) => WeakQuestion.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return ExamDetailStats(
      totalAssigned: (json['total_assigned'] as num?)?.toInt() ?? 0,
      totalCompleted: (json['total_completed'] as num?)?.toInt() ?? 0,
      passed: (json['passed'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      avgPercentage: json['avg_percentage'] != null
          ? (json['avg_percentage'] as num).toDouble()
          : null,
      highestScore: json['highest_score'] != null
          ? (json['highest_score'] as num).toDouble()
          : null,
      lowestScore: json['lowest_score'] != null
          ? (json['lowest_score'] as num).toDouble()
          : null,
      weakQuestions: weak,
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Controller
// ══════════════════════════════════════════════════════════════

class ClassDetailController extends GetxController {
  final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
  SupabaseClient get _client => Supabase.instance.client;
  int get _teacherId =>
      int.parse(Get.find<AuthService>().currentUser.value!.id);

  final classItem = Rxn<ClassModel>();
  final students = <StudentModel>[].obs;
  final isLoading = true.obs;
  final selectedTabIndex = 0.obs;

  // ── اختبارات الفصل ───────────────────────────────────────
  final classExams = <ClassExamStat>[].obs;
  final isLoadingExams = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['class'] != null) {
      classItem.value = arguments['class'] as ClassModel;
      // تحميل الطلاب والاختبارات معاً فور فتح الشاشة
      loadStudents();
      loadClassExams();
    }

    ever(selectedTabIndex, (index) {
      if (index == 1 && classExams.isEmpty) {
        loadClassExams();
      }
    });
  }

  Future<void> loadStudents() async {
    isLoading.value = true;
    try {
      final c = classItem.value;
      if (c != null) {
        final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
        if (sectionId > 0) {
          final list = await _classesRepo.getStudentsBySection(
            sectionId: sectionId,
            sectionName: c.name,
          );
          students.value = list;
          // جلب معدلات الاختبارات الرسمية
          await _loadStudentAverages(sectionId);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStudentAverages(int sectionId) async {
    try {
      final res = await _client.rpc(
        'get_section_students_with_avg',
        params: {'p_section_id': sectionId, 'p_teacher_id': _teacherId},
      );
      if (res == null) return;
      final Map<int, double> avgMap = {};
      for (final item in res as List) {
        final m = Map<String, dynamic>.from(item);
        avgMap[(m['student_id'] as num).toInt()] =
            (m['avg_score'] as num?)?.toDouble() ?? 0;
      }
      final updated = students.map((s) {
        final avg = avgMap[int.tryParse(s.id) ?? 0] ?? 0.0;
        return StudentModel(
          id: s.id,
          name: s.name,
          email: s.email,
          studentCode: s.studentCode,
          classId: s.classId,
          className: s.className,
          profileImage: s.profileImage,
          averageScore: avg,
          totalQuizzes: s.totalQuizzes,
          completedQuizzes: s.completedQuizzes,
          masteryLevel: avg >= 85
              ? 'Mastered'
              : avg >= 70
              ? 'Proficient'
              : avg >= 50
              ? 'Developing'
              : 'Needs Improvement',
          subjectPerformance: s.subjectPerformance,
          lastActive: s.lastActive,
        );
      }).toList();
      students.value = updated;
      students.refresh();
    } catch (e) {
      debugPrint('_loadStudentAverages error: \$e');
    }
  }

  Future<void> loadClassExams() async {
    final c = classItem.value;
    if (c == null) return;
    final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
    if (sectionId <= 0) return;

    isLoadingExams.value = true;
    try {
      final res = await _client.rpc(
        'get_class_exams_with_stats',
        params: {'p_section_id': sectionId, 'p_teacher_id': _teacherId},
      );
      if (res == null) {
        classExams.value = [];
        return;
      }
      final list = res as List;
      classExams.value = list
          .map(
            (e) => ClassExamStat.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } catch (e) {
      debugPrint('loadClassExams error: $e');
    } finally {
      isLoadingExams.value = false;
    }
  }

  // ── فتح تفاصيل اختبار محدد ───────────────────────────────
  void openExamDetail(ClassExamStat exam) {
    final c = classItem.value;
    if (c == null) return;
    final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
    Get.toNamed(
      AppRoutes.examDetail,
      arguments: {'exam': exam, 'sectionId': sectionId},
    );
  }

  void changeTab(int index) => selectedTabIndex.value = index;

  void viewStudentDetail(StudentModel student) =>
      Get.toNamed(AppRoutes.studentDetail, arguments: {'student': student});

  void createQuizForClass() => Get.toNamed(AppRoutes.quizBuilder);

  void openAttendance() {
    final c = classItem.value;
    if (c == null || students.isEmpty) return;
    final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
    if (sectionId <= 0) return;
    Get.toNamed(
      AppRoutes.attendance,
      arguments: {
        'sectionId': sectionId,
        'sectionName': c.name,
        'students': students.toList(),
      },
    );
  }
}
