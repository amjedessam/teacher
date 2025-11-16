// import 'package:get/get.dart';
// import '../../data/services/mock_data_service.dart';

// class QuestionQualityController extends GetxController {
//   final mockDataService = MockDataService();
//   final isLoading = true.obs;
//   final questions = [].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadQuestions();
//   }

//   Future loadQuestions() async {
//     isLoading.value = true;
//     await Future.delayed(const Duration(milliseconds: 500));
//     questions.value = mockDataService.getQuestions();
//     isLoading.value = false;
//   }

//   List get excellentQuestions =>
//       questions.where((q) => q.quality == 'Excellent').toList();

//   List get goodQuestions =>
//       questions.where((q) => q.quality == 'Good').toList();

//   List get fairQuestions =>
//       questions.where((q) => q.quality == 'Fair').toList();

//   List get poorQuestions =>
//       questions.where((q) => q.quality == 'Poor').toList();
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../data/models/question_model.dart';
// import '../../data/repositories/question_repository.dart';
// import '../../data/services/question_analysis_service.dart';

// class QuestionQualityController extends GetxController {
//   final QuestionRepository _questionRepo = Get.find();
//   final QuestionAnalysisService _analysisService = Get.find();

//   final isLoading = true.obs;
//   final questions = <QuestionModel>[].obs;
//   final qualityStats = <String, dynamic>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadQuestions();
//     loadQualityStats();
//   }

//   Future<void> loadQuestions() async {
//     try {
//       isLoading.value = true;

//       // ✅ جلب جميع الأسئلة
//       final allQuestions = await _questionRepo.getQuestions();
//       questions.value = allQuestions;
//     } catch (e) {
//       Get.snackbar('خطأ', 'فشل تحميل الأسئلة');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> loadQualityStats() async {
//     try {
//       // ✅ حساب إحصائيات الجودة
//       final stats = await _analysisService.getBankQualityStats();
//       qualityStats.value = stats;
//     } catch (e) {
//       print('Error loading quality stats: $e');
//     }
//   }

//   /// الأسئلة حسب التصنيف
//   List<QuestionModel> get excellentQuestions =>
//       questions.where((q) => q.quality == 'ممتاز').toList();

//   List<QuestionModel> get goodQuestions =>
//       questions.where((q) => q.quality == 'جيد').toList();

//   List<QuestionModel> get fairQuestions =>
//       questions.where((q) => q.quality == 'مقبول').toList();

//   List<QuestionModel> get poorQuestions =>
//       questions.where((q) => q.quality == 'يحتاج مراجعة').toList();

//   /// الأسئلة المشبوهة (تحتاج مراجعة فورية)
//   List<QuestionModel> get suspiciousQuestions {
//     return questions.where((q) {
//       return q.difficultyIndex < 0.3 ||
//           q.difficultyIndex > 0.9 ||
//           q.discriminationIndex < 0.2;
//     }).toList();
//   }

//   /// إعادة تحليل جميع الأسئلة
//   /// (يستدعى عند وجود بيانات محاولات جديدة)
//   Future<void> reanalyzeAllQuestions() async {
//     try {
//       isLoading.value = true;

//       // TODO: أنت ستضيف لاحقاً جلب بيانات المحاولات الفعلية من الـ API
//       // final attempts = await _api.getStudentAttempts();

//       // حالياً: استخدام بيانات وهمية للتوضيح
//       final mockAttempts = _generateMockAttempts();

//       final analyzedQuestions = await _analysisService.analyzeBatch(
//         questions: questions,
//         attempts: mockAttempts,
//       );

//       questions.value = analyzedQuestions;
//       await loadQualityStats();

//       Get.snackbar(
//         'تم التحليل',
//         'تم إعادة تحليل ${questions.length} سؤال بنجاح',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar('خطأ', 'فشل تحليل الأسئلة');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// توليد بيانات محاولات وهمية للتجربة
//   /// TODO: احذف هذا واستبدله بـ API call فعلي
//   List<StudentAttempt> _generateMockAttempts() {
//     final attempts = <StudentAttempt>[];

//     // محاكاة 30 طالب × 5 أسئلة = 150 محاولة
//     for (int i = 0; i < 30; i++) {
//       final studentScore = 40.0 + (i * 2.0); // درجات من 40 إلى 98

//       for (final question in questions.take(5)) {
//         // الطلاب الأقوياء يجيبون صح أكثر
//         final answeredCorrectly = studentScore > 70
//             ? (i % 3 != 0) // 66% صح للأقوياء
//             : (i % 3 == 0); // 33% صح للضعاف

//         attempts.add(
//           StudentAttempt(
//             studentId: 'S${i.toString().padLeft(3, '0')}',
//             questionId: question.id,
//             answeredCorrectly: answeredCorrectly,
//             totalScore: studentScore,
//           ),
//         );
//       }
//     }

//     return attempts;
//   }

//   /// عرض تفاصيل سؤال معين
//   void viewQuestionDetails(QuestionModel question) {
//     Get.dialog(
//       AlertDialog(
//         title: Text('تفاصيل السؤال'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('السؤال:', style: TextStyle(fontWeight: FontWeight.bold)),
//               Text(question.questionText),
//               SizedBox(height: 16),
//               _buildStatRow(
//                 'مؤشر الصعوبة',
//                 (question.difficultyIndex * 100).toStringAsFixed(1) + '%',
//               ),
//               _buildStatRow(
//                 'مؤشر التمييز',
//                 (question.discriminationIndex * 100).toStringAsFixed(1) + '%',
//               ),
//               _buildStatRow('التصنيف', question.quality),
//               _buildStatRow('عدد الاستخدامات', question.timesUsed.toString()),
//               _buildStatRow('إجابات صحيحة', question.timesCorrect.toString()),
//               _buildStatRow('إجابات خاطئة', question.timesIncorrect.toString()),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: Text('إغلاق')),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label + ':'),
//           Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/data/models/question_model.dart';
import '../../../app/data/services/question_analysis_service.dart';

class QuestionQualityController extends GetxController
    with StateMixin<List<QuestionModel>> {
  final QuestionAnalysisService analysisService;

  // متغيرات تفاعلية لعرض الإحصائيات
  final RxMap<String, dynamic> qualityStats = <String, dynamic>{}.obs;

  // قائمة الأسئلة التي تحتاج مراجعة
  final RxList<QuestionModel> suspiciousQuestions = <QuestionModel>[].obs;

  QuestionQualityController({required this.analysisService});

  @override
  void onInit() {
    super.onInit();
    fetchQualityData();
  }

  Future<void> fetchQualityData() async {
    try {
      change(null, status: RxStatus.loading()); // بدء التحميل

      // 1. جلب الإحصائيات العامة لجودة بنك الأسئلة
      final stats = await analysisService.getBankQualityStats();
      qualityStats.value = stats;

      // 2. جلب الأسئلة المشبوهة (التي تحتاج مراجعة)
      final suspicious = await analysisService.getSuspiciousQuestions();
      suspiciousQuestions.assignAll(suspicious);

      // عرض الأسئلة المشبوهة في حالة النجاح
      if (suspicious.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(suspicious, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error('حدث خطأ أثناء جلب البيانات: $e'));
    }
  }

  // دالة مساعدة لتحديد لون التصنيف
  Color getQualityColor(String quality) {
    switch (quality) {
      case 'ممتاز':
        return const Color(0xFF4CAF50); // Success Green
      case 'جيد':
        return const Color(0xFF2196F3); // Info Blue
      case 'مقبول':
        return const Color(0xFFFF9800); // Warning Orange
      case 'يحتاج مراجعة':
        return const Color(0xFFF44336); // Error Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  // دالة مساعدة لتحديد لون مؤشر التمييز
  Color getDiscriminationColor(double discI) {
    if (discI >= 0.4) return const Color(0xFF4CAF50);
    if (discI >= 0.2) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
