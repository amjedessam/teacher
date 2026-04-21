import 'package:get/get.dart';
import '../models/question_model.dart';
import '../repositories/question_repository.dart';
import 'package:teacher/app/data/services/ai_service.dart';

/// Student attempt data for discrimination index calculation
class StudentAttempt {
  final String studentId;
  final String questionId;
  final bool answeredCorrectly;
  final double totalScore; // إجمالي درجة الطالب في الاختبار

  StudentAttempt({
    required this.studentId,
    required this.questionId,
    required this.answeredCorrectly,
    required this.totalScore,
  });
}

/// خدمة تحليل جودة الأسئلة
/// تحسب Difficulty Index و Discrimination Index
class QuestionAnalysisService extends GetxService {
  final QuestionRepository _questionRepo = Get.find();

  /// حساب Difficulty Index (مؤشر الصعوبة)
  double calculateDifficultyIndex(QuestionModel question) {
    if (question.timesUsed == 0) return 0.5; // افتراضي للأسئلة الجديدة
    return question.timesCorrect / question.timesUsed;
  }

  /// حساب Discrimination Index (مؤشر التمييز)
  double calculateDiscriminationIndex({
    required QuestionModel question,
    required List<StudentAttempt> allAttempts,
  }) {
    if (allAttempts.isEmpty) return 0.3; // افتراضي

    // فلترة المحاولات لهذا السؤال فقط
    final questionAttempts = allAttempts
        .where((attempt) => attempt.questionId == question.id)
        .toList();

    if (questionAttempts.isEmpty) return 0.3;

    // ترتيب حسب الدرجة الإجمالية (تنازلي)
    final sorted = List<StudentAttempt>.from(questionAttempts)
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    // استخدام floor() بدلاً من ceil() لضمان أننا لا نتجاوز حجم القائمة
    // ونستخدم 27% من إجمالي عدد المحاولات
    final totalAttempts = sorted.length;
    final groupSize = (totalAttempts * 0.27).floor();

    // إذا كان حجم المجموعة أقل من 10، نعتبر البيانات غير كافية للتحليل الدقيق
    if (groupSize < 10) return 0.3;

    // المجموعة العليا (أعلى 27%)
    final topStudents = sorted.take(groupSize).toList();
    // المجموعة الدنيا (أقل 27%)
    final bottomStudents = sorted.skip(totalAttempts - groupSize).toList();

    // حساب عدد الإجابات الصحيحة في كل مجموعة
    final topCorrect = topStudents.where((s) => s.answeredCorrectly).length;
    final bottomCorrect = bottomStudents
        .where((s) => s.answeredCorrectly)
        .length;

    // حساب نسبة الإجابات الصحيحة (P_upper و P_lower)
    final topRate = topCorrect / groupSize;
    final bottomRate = bottomCorrect / groupSize;

    // مؤشر التمييز (DI)
    return topRate - bottomRate;
  }

  /// تصنيف جودة السؤال بناءً على DI و DiscI
  String getQualityLabel({
    required double difficultyIndex,
    required double discriminationIndex,
  }) {
    // أسئلة تحتاج مراجعة بسبب التمييز الضعيف أو السهولة/الصعوبة المفرطة
    if (discriminationIndex < 0.2 ||
        difficultyIndex < 0.3 ||
        difficultyIndex > 0.9) {
      return 'يحتاج مراجعة';
    }

    // أسئلة ممتازة (متوسطة الصعوبة وتميز جيداً)
    if (difficultyIndex >= 0.3 &&
        difficultyIndex <= 0.7 &&
        discriminationIndex >= 0.4) {
      return 'ممتاز';
    }

    // أسئلة جيدة
    if (discriminationIndex >= 0.3) {
      return 'جيد';
    }

    return 'مقبول';
  }

  /// تحديث جودة السؤال بعد تحليله
  Future<QuestionModel> analyzeAndUpdateQuestion({
    required QuestionModel question,
    required List<StudentAttempt> attempts,
  }) async {
    final di = calculateDifficultyIndex(question);
    final discI = calculateDiscriminationIndex(
      question: question,
      allAttempts: attempts,
    );
    final quality = getQualityLabel(
      difficultyIndex: di,
      discriminationIndex: discI,
    );

    // إنشاء سؤال محدث بالمؤشرات الجديدة
    final updatedQuestion = QuestionModel(
      id: question.id,
      questionText: question.questionText,
      questionType: question.questionType,
      options: question.options,
      correctAnswer: question.correctAnswer,
      explanation: question.explanation,
      difficulty: question.difficulty,
      cognitiveSkill: question.cognitiveSkill,
      subject: question.subject,
      chapter: question.chapter,
      unit: question.unit,
      timesUsed: question.timesUsed,
      timesCorrect: question.timesCorrect,
      timesIncorrect: question.timesIncorrect,
      difficultyIndex: di,
      discriminationIndex: discI,
      quality: quality,
      isApproved: question.isApproved,
      createdAt: question.createdAt,
    );

    // حفظ في الـ Repository
    await _questionRepo.updateQuestion(updatedQuestion);

    return updatedQuestion;
  }

  /// الحصول على الأسئلة التي تحتاج مراجعة
  Future<List<QuestionModel>> getSuspiciousQuestions() async {
    return await _questionRepo.getSuspiciousQuestions();
  }

  /// إحصائيات عامة عن جودة بنك الأسئلة
  Future<Map<String, dynamic>> getBankQualityStats() async {
    final allQuestions = await _questionRepo.getQuestions();

    final excellent = allQuestions.where((q) => q.quality == 'ممتاز').length;
    final good = allQuestions.where((q) => q.quality == 'جيد').length;
    final fair = allQuestions.where((q) => q.quality == 'مقبول').length;
    final needsReview = allQuestions
        .where((q) => q.quality == 'يحتاج مراجعة')
        .length;

    return {
      'total': allQuestions.length,
      'excellent': excellent,
      'good': good,
      'fair': fair,
      'needsReview': needsReview,
      'excellentPercentage': allQuestions.isEmpty
          ? 0.0
          : (excellent / allQuestions.length * 100),
      'needsReviewPercentage': allQuestions.isEmpty
          ? 0.0
          : (needsReview / allQuestions.length * 100),
    };
  }

  // Future<String> generateQualitySummary() async {
  //   final aiService = Get.find<AiService>();
  //   final stats = await getBankQualityStats();
  //   return await aiService.summarizeQuestionBankQuality(stats);
  // }
}
