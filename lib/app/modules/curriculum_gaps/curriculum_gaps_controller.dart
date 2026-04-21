// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../data/services/auth_service.dart';

// // ── Models ───────────────────────────────────────────────────

// class QuestionGap {
//   final int questionId;
//   final String questionText;
//   final String chapterName;
//   final String subjectName;
//   final int totalStudents;
//   final int failedStudents;
//   final double failureRate;

//   QuestionGap({
//     required this.questionId,
//     required this.questionText,
//     required this.chapterName,
//     required this.subjectName,
//     required this.totalStudents,
//     required this.failedStudents,
//     required this.failureRate,
//   });

//   factory QuestionGap.fromJson(Map<String, dynamic> json) => QuestionGap(
//     questionId: (json['question_id'] as num).toInt(),
//     questionText: json['question_text']?.toString() ?? '',
//     chapterName: json['chapter_name']?.toString() ?? '',
//     subjectName: json['subject_name']?.toString() ?? '',
//     totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
//     failedStudents: (json['failed_students'] as num?)?.toInt() ?? 0,
//     failureRate: (json['failure_rate'] as num?)?.toDouble() ?? 0,
//   );

//   GapSeverity get severity {
//     if (failureRate >= 60) return GapSeverity.critical;
//     if (failureRate >= 40) return GapSeverity.high;
//     if (failureRate >= 20) return GapSeverity.medium;
//     return GapSeverity.low;
//   }
// }

// class ChapterGap {
//   final String chapterName;
//   final String subjectName;
//   final List<QuestionGap> questions;

//   ChapterGap({
//     required this.chapterName,
//     required this.subjectName,
//     required this.questions,
//   });

//   double get avgFailureRate {
//     if (questions.isEmpty) return 0;
//     return questions.map((q) => q.failureRate).reduce((a, b) => a + b) /
//         questions.length;
//   }

//   int get weakQuestionsCount =>
//       questions.where((q) => q.failureRate >= 40).length;

//   GapSeverity get severity {
//     if (avgFailureRate >= 60) return GapSeverity.critical;
//     if (avgFailureRate >= 40) return GapSeverity.high;
//     if (avgFailureRate >= 20) return GapSeverity.medium;
//     return GapSeverity.low;
//   }

//   String get recommendation {
//     if (avgFailureRate >= 60) {
//       return 'خطورة عالية: يحتاج إعادة شرح الفصل بالكامل وتخصيص حصص دعم إضافية';
//     } else if (avgFailureRate >= 40) {
//       return 'يحتاج تدخل: مراجعة شاملة وإضافة تمارين تطبيقية مع دعم فردي للمتعثرين';
//     } else if (avgFailureRate >= 20) {
//       return 'يحتاج متابعة: مراجعة سريعة للنقاط الصعبة وواجبات إضافية للتقوية';
//     }
//     return 'أداء جيد في هذا الفصل';
//   }
// }

// enum GapSeverity { critical, high, medium, low }

// // ── Controller ───────────────────────────────────────────────

// class CurriculumGapsController extends GetxController {
//   final AuthService _authService = Get.find<AuthService>();
//   SupabaseClient get _client => Supabase.instance.client;
//   int get _teacherId => int.parse(_authService.currentUser.value!.id);

//   final isLoading = true.obs;
//   final questionGaps = <QuestionGap>[].obs;
//   final chapterGaps = <ChapterGap>[].obs;
//   final selectedSeverity = Rxn<GapSeverity>();

//   int get totalChapters => chapterGaps.length;
//   int get criticalCount =>
//       chapterGaps.where((c) => c.severity == GapSeverity.critical).length;
//   int get highCount =>
//       chapterGaps.where((c) => c.severity == GapSeverity.high).length;
//   int get totalWeakQuestions =>
//       questionGaps.where((q) => q.failureRate >= 40).length;

//   List<ChapterGap> get filteredChapterGaps {
//     if (selectedSeverity.value == null) return chapterGaps;
//     return chapterGaps
//         .where((c) => c.severity == selectedSeverity.value)
//         .toList();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     loadGaps();
//   }

//   Future<void> loadGaps() async {
//     try {
//       isLoading.value = true;
//       final res = await _client.rpc(
//         'get_curriculum_gaps_analysis',
//         params: {'p_teacher_id': _teacherId},
//       );
//       if (res == null || (res as List).isEmpty) {
//         questionGaps.value = [];
//         chapterGaps.value = [];
//         return;
//       }
//       final gaps = (res as List)
//           .map((e) => QuestionGap.fromJson(Map<String, dynamic>.from(e)))
//           .toList();
//       questionGaps.value = gaps;
//       _groupByChapter(gaps);
//     } catch (e) {
//       debugPrint('loadGaps error: $e');
//       Get.snackbar('خطأ', 'فشل تحليل الفجوات المنهجية');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void _groupByChapter(List<QuestionGap> gaps) {
//     final Map<String, List<QuestionGap>> map = {};
//     for (final q in gaps) {
//       final key = '${q.subjectName}:${q.chapterName}';
//       map[key] ??= [];
//       map[key]!.add(q);
//     }
//     final chapters = map.entries.map((e) {
//       final first = e.value.first;
//       return ChapterGap(
//         chapterName: first.chapterName,
//         subjectName: first.subjectName,
//         questions: e.value,
//       );
//     }).toList();
//     chapters.sort((a, b) => b.avgFailureRate.compareTo(a.avgFailureRate));
//     chapterGaps.value = chapters;
//   }

//   void filterBySeverity(GapSeverity? severity) =>
//       selectedSeverity.value = severity;

//   Future<void> reanalyze() async {
//     await loadGaps();
//     Get.snackbar(
//       'تم التحليل',
//       'تم إعادة تحليل الفجوات المنهجية',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   Color getSeverityColor(GapSeverity severity) {
//     switch (severity) {
//       case GapSeverity.critical:
//         return const Color(0xFFF44336);
//       case GapSeverity.high:
//         return const Color(0xFFFF9800);
//       case GapSeverity.medium:
//         return const Color(0xFFFFEB3B);
//       case GapSeverity.low:
//         return const Color(0xFF4CAF50);
//     }
//   }

//   String getSeverityLabel(GapSeverity severity) {
//     switch (severity) {
//       case GapSeverity.critical:
//         return 'حرج';
//       case GapSeverity.high:
//         return 'مرتفع';
//       case GapSeverity.medium:
//         return 'متوسط';
//       case GapSeverity.low:
//         return 'منخفض';
//     }
//   }
// }
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teacher/app/data/models/gapModel.dart';
class CurriculumGapsController extends GetxController {
  final chapterGaps = <ChapterGap>[].obs;
  final isLoading = false.obs;
  final selectedSeverity = Rxn<GapSeverity>();

  // إحصائيات سريعة
  int get totalChapters => chapterGaps.length;
  int get criticalCount => chapterGaps.where((g) => g.severity == GapSeverity.critical).length;
  int get totalWeakQuestions => chapterGaps.fold(0, (sum, item) => sum + item.questions.length);

  List<ChapterGap> get filteredChapterGaps {
    if (selectedSeverity.value == null) return chapterGaps;
    return chapterGaps.where((g) => g.severity == selectedSeverity.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
  if (args != null && args['gaps'] != null) {
    chapterGaps.value = args['gaps'] as List<ChapterGap>;
  }
    loadGaps();
  }
  

  Future<void> loadGaps() async {
    isLoading.value = true;
    // هنا تقوم بجلب البيانات من Repository الخاص بك 
    // وتحويلها لموديل ChapterGap
    await Future.delayed(const Duration(seconds: 1)); // محاكاة تحميل
    isLoading.value = false;
  }

  void filterBySeverity(GapSeverity? severity) => selectedSeverity.value = severity;

  Color getSeverityColor(GapSeverity severity) {
    switch (severity) {
      case GapSeverity.critical: return const Color(0xFFF44336);
      case GapSeverity.high: return const Color(0xFFFF9800);
      case GapSeverity.medium: return const Color(0xFF2196F3);
      case GapSeverity.low: return const Color(0xFF4CAF50);
    }
  }

  String getSeverityLabel(GapSeverity severity) {
    switch (severity) {
      case GapSeverity.critical: return "حرج";
      case GapSeverity.high: return "مرتفع";
      case GapSeverity.medium: return "متوسط";
      case GapSeverity.low: return "منخفض";
    }
  }

  void reanalyze() {
    // استدعاء دالة الذكاء الاصطناعي التي صممناها سابقاً
    loadGaps();
  }
  /// تحليل أداء الفصل واكتشاف الفجوات المنهجية بناءً على إحصائيات الاختبارات والطلاب
}
