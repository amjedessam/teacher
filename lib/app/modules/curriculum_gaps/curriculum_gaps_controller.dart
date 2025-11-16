import 'package:get/get.dart';
import '../../data/services/curriculum_gap_analysis_service.dart';

class CurriculumGapsController extends GetxController {
  final CurriculumGapAnalysisService _analysisService = Get.find();

  final isLoading = true.obs;
  final gaps = <CurriculumGap>[].obs;
  final gapStats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadGaps();
  }

  Future<void> loadGaps() async {
    try {
      isLoading.value = true;

      final mockResults = _generateMockQuizResults();

      final detectedGaps = await _analysisService.analyzeGapsForClass(
        classId: 'C001',
        quizResults: mockResults,
      );

      gaps.value = detectedGaps;

      final stats = await _analysisService.getGapStatistics(detectedGaps);
      gapStats.value = stats;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحليل الفجوات المنهجية');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reanalyze() async {
    await loadGaps();
    Get.snackbar(
      'تم التحليل',
      'تم إعادة تحليل الفجوات المنهجية',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<QuizResult> _generateMockQuizResults() {
    final results = <QuizResult>[];

    for (int i = 0; i < 30; i++) {
      final studentId = 'S${i.toString().padLeft(3, '0')}';

      results.add(
        QuizResult(
          studentId: studentId,
          studentName: 'طالب $i',
          quizId: 'QZ001',
          unit: 'المعادلات الخطية',
          chapter: 'الجبر',
          score: 60 + (i % 10) * 4.0,
          totalQuestions: 20,
          correctAnswers: 12 + (i % 10),
          completedAt: DateTime.now(),
        ),
      );

      results.add(
        QuizResult(
          studentId: studentId,
          studentName: 'طالب $i',
          quizId: 'QZ002',
          unit: 'المعادلات التربيعية',
          chapter: 'الجبر',
          score: i < 20 ? 45.0 : 75.0,

          totalQuestions: 20,
          correctAnswers: i < 20 ? 9 : 15,
          completedAt: DateTime.now(),
        ),
      );

      results.add(
        QuizResult(
          studentId: studentId,
          studentName: 'طالب $i',
          quizId: 'QZ003',
          unit: 'حساب المثلثات الأساسي',
          chapter: 'حساب المثلثات',
          score: i < 14 ? 50.0 : 72.0,
          totalQuestions: 20,
          correctAnswers: i < 14 ? 10 : 14,
          completedAt: DateTime.now(),
        ),
      );
    }

    return results;
  }
}
