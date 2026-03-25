// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../app/data/models/question_model.dart';
// import '../../../app/data/services/question_analysis_service.dart';

// class QuestionQualityController extends GetxController
//     with StateMixin<List<QuestionModel>> {
//   final QuestionAnalysisService analysisService;

//   // متغيرات تفاعلية لعرض الإحصائيات
//   final RxMap<String, dynamic> qualityStats = <String, dynamic>{}.obs;

//   // قائمة الأسئلة التي تحتاج مراجعة
//   final RxList<QuestionModel> suspiciousQuestions = <QuestionModel>[].obs;

//   QuestionQualityController({required this.analysisService});

//   @override
//   void onInit() {
//     super.onInit();
//     fetchQualityData();
//   }

//   Future<void> fetchQualityData() async {
//     try {
//       change(null, status: RxStatus.loading()); // بدء التحميل

//       // 1. جلب الإحصائيات العامة لجودة بنك الأسئلة
//       final stats = await analysisService.getBankQualityStats();
//       qualityStats.value = stats;

//       // 2. جلب الأسئلة المشبوهة (التي تحتاج مراجعة)
//       final suspicious = await analysisService.getSuspiciousQuestions();
//       suspiciousQuestions.assignAll(suspicious);

//       // عرض الأسئلة المشبوهة في حالة النجاح
//       if (suspicious.isEmpty) {
//         change(null, status: RxStatus.empty());
//       } else {
//         change(suspicious, status: RxStatus.success());
//       }
//     } catch (e) {
//       change(null, status: RxStatus.error('حدث خطأ أثناء جلب البيانات: $e'));
//     }
//   }

//   // دالة مساعدة لتحديد لون التصنيف
//   Color getQualityColor(String quality) {
//     switch (quality) {
//       case 'ممتاز':
//         return const Color(0xFF4CAF50); // Success Green
//       case 'جيد':
//         return const Color(0xFF2196F3); // Info Blue
//       case 'مقبول':
//         return const Color(0xFFFF9800); // Warning Orange
//       case 'يحتاج مراجعة':
//         return const Color(0xFFF44336); // Error Red
//       default:
//         return const Color(0xFF9E9E9E); // Grey
//     }
//   }

//   // دالة مساعدة لتحديد لون مؤشر التمييز
//   Color getDiscriminationColor(double discI) {
//     if (discI >= 0.4) return const Color(0xFF4CAF50);
//     if (discI >= 0.2) return const Color(0xFFFF9800);
//     return const Color(0xFFF44336);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/data/models/question_model.dart';
import '../../../app/data/repositories/question_repository.dart';

class QuestionQualityController extends GetxController {
  final QuestionRepository _questionRepo = Get.find();

  final isLoading = true.obs;

  // قائمة الأسئلة الكاملة
  final allQuestions = <QuestionModel>[].obs;

  // قائمة الأسئلة بعد الفلترة
  final filteredQuestions = <QuestionModel>[].obs;

  // فلاتر
  final selectedSubjectId = Rxn<String>();
  final selectedQuality = Rxn<String>();
  final selectedDifficulty = Rxn<String>();

  // قوائم المواد المتاحة (مستخرجة من البيانات)
  final availableSubjects = <Map<String, String>>[].obs;

  // إحصائيات سريعة
  int get totalQuestions => allQuestions.length;
  int get excellentCount =>
      allQuestions.where((q) => q.quality == 'ممتاز').length;
  int get goodCount => allQuestions.where((q) => q.quality == 'جيد').length;
  int get fairCount => allQuestions.where((q) => q.quality == 'مقبول').length;
  int get needsReviewCount =>
      allQuestions.where((q) => q.quality == 'يحتاج مراجعة').length;
  int get unusedCount =>
      allQuestions.where((q) => q.quality == 'لم يُستخدم بعد').length;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;
      final questions = await _questionRepo.getQuestions();
      allQuestions.value = questions;
      filteredQuestions.value = questions;

      // استخراج المواد المتاحة
      final subjectsMap = <String, String>{};
      for (final q in questions) {
        if (q.subjectId.isNotEmpty && q.subject.isNotEmpty) {
          subjectsMap[q.subjectId] = q.subject;
        }
      }
      availableSubjects.value = subjectsMap.entries
          .map((e) => {'id': e.key, 'name': e.value})
          .toList();
    } catch (e) {
      debugPrint('loadQuestions error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterBySubject(String? subjectId) {
    selectedSubjectId.value = subjectId;
    _applyFilters();
  }

  void filterByQuality(String? quality) {
    selectedQuality.value = quality;
    _applyFilters();
  }

  void filterByDifficulty(String? difficulty) {
    selectedDifficulty.value = difficulty;
    _applyFilters();
  }

  void clearFilters() {
    selectedSubjectId.value = null;
    selectedQuality.value = null;
    selectedDifficulty.value = null;
    filteredQuestions.value = allQuestions;
  }

  void _applyFilters() {
    var result = allQuestions.toList();

    if (selectedSubjectId.value != null) {
      result = result
          .where((q) => q.subjectId == selectedSubjectId.value)
          .toList();
    }
    if (selectedQuality.value != null) {
      result = result.where((q) => q.quality == selectedQuality.value).toList();
    }
    if (selectedDifficulty.value != null) {
      result = result
          .where((q) => q.difficulty == selectedDifficulty.value)
          .toList();
    }

    filteredQuestions.value = result;
  }

  Color getQualityColor(String quality) {
    switch (quality) {
      case 'ممتاز':
        return const Color(0xFF4CAF50);
      case 'جيد':
        return const Color(0xFF2196F3);
      case 'مقبول':
        return const Color(0xFFFF9800);
      case 'يحتاج مراجعة':
        return const Color(0xFFF44336);
      case 'لم يُستخدم بعد':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'سهل';
      case 'medium':
        return 'متوسط';
      case 'hard':
        return 'صعب';
      default:
        return difficulty;
    }
  }
}
