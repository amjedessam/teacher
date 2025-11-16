import 'package:get/get.dart';

/// نتيجة طالب في اختبار
class QuizResult {
  final String studentId;
  final String studentName;
  final String quizId;
  final String unit;
  final String chapter;
  final double score; // الدرجة من 100
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;

  QuizResult({
    required this.studentId,
    required this.studentName,
    required this.quizId,
    required this.unit,
    required this.chapter,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,

    required this.completedAt,
  });

  bool get isPassed => score >= 60; // الحد الأدنى للنجاح
  bool get isFailed => !isPassed;
}

/// فجوة منهجية تم اكتشافها
class CurriculumGap {
  final String unit;
  final String chapter;
  final double failureRate; // نسبة الفشل (0.0 - 1.0)
  final int totalStudents;
  final int failedStudents;
  final List<String> affectedStudentIds;
  final GapSeverity severity;
  final String recommendation;
  final DateTime detectedAt;

  CurriculumGap({
    required this.unit,
    required this.chapter,

    required this.failureRate,
    required this.totalStudents,
    required this.failedStudents,
    required this.affectedStudentIds,
    required this.severity,
    required this.recommendation,
    DateTime? detectedAt,
  }) : detectedAt = detectedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'unit': unit,
    'chapter': chapter,
    'failureRate': failureRate,
    'totalStudents': totalStudents,
    'failedStudents': failedStudents,
    'affectedStudentIds': affectedStudentIds,
    'severity': severity.name,
    'recommendation': recommendation,
    'detectedAt': detectedAt.toIso8601String(),
  };
}

/// درجة خطورة الفجوة
enum GapSeverity {
  critical, // أكثر من 60% فشل
  high, // 40-60% فشل
  medium, // 30-40% فشل
  low, // 20-30% فشل
}

/// أداء وحدة دراسية
class UnitPerformance {
  final String unit;
  final String chapter;
  final List<QuizResult> results = [];

  UnitPerformance({required this.unit, required this.chapter});

  void addResult(QuizResult result) {
    results.add(result);
  }

  int get totalStudents {
    final uniqueStudents = results.map((r) => r.studentId).toSet();
    return uniqueStudents.length;
  }

  int get failedStudents {
    final uniqueFailed = results
        .where((r) => r.isFailed)
        .map((r) => r.studentId)
        .toSet();
    return uniqueFailed.length;
  }

  double get failureRate {
    if (totalStudents == 0) return 0.0;
    return failedStudents / totalStudents;
  }

  double get averageScore {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.score);
    return sum / results.length;
  }

  List<String> get failedStudentIds {
    return results
        .where((r) => r.isFailed)
        .map((r) => r.studentId)
        .toSet()
        .toList();
  }
}

/// خدمة تحليل الفجوات المنهجية
///
/// تحدد الموضوعات التي يعاني فيها أكثر من 40% من الطلاب
/// وفقاً لمتطلبات مشروع التخرج
class CurriculumGapAnalysisService extends GetxService {
  /// عتبة الفشل الافتراضية (40%)
  static const double defaultFailureThreshold = 0.40;

  /// تحليل الفجوات في فصل معين
  ///
  /// يحلل جميع نتائج الاختبارات ويحدد:

  /// - الوحدات التي يفشل فيها أكثر من 40% من الطلاب
  /// - درجة خطورة كل فجوة
  /// - التوصيات المناسبة
  Future<List<CurriculumGap>> analyzeGapsForClass({
    required String classId,
    required List<QuizResult> quizResults,
    double failureThreshold = defaultFailureThreshold,
  }) async {
    if (quizResults.isEmpty) return [];

    // تجميع النتائج حسب الوحدة والفصل
    final Map<String, UnitPerformance> performanceMap = {};

    for (final result in quizResults) {
      final key = '${result.chapter}:${result.unit}';
      performanceMap[key] ??= UnitPerformance(
        unit: result.unit,
        chapter: result.chapter,
      );

      performanceMap[key]!.addResult(result);
    }

    // تحليل كل وحدة وإنشاء Gaps
    final List<CurriculumGap> gaps = [];

    for (final performance in performanceMap.values) {
      // تخطي الوحدات بدون بيانات كافية
      if (performance.totalStudents < 3) continue;

      final failureRate = performance.failureRate;

      // إذا كان معدل الفشل أعلى من العتبة
      if (failureRate >= failureThreshold) {
        final severity = _calculateSeverity(failureRate);
        final recommendation = _generateRecommendation(
          unit: performance.unit,
          chapter: performance.chapter,
          failureRate: failureRate,

          averageScore: performance.averageScore,
        );

        gaps.add(
          CurriculumGap(
            unit: performance.unit,
            chapter: performance.chapter,
            failureRate: failureRate,
            totalStudents: performance.totalStudents,
            failedStudents: performance.failedStudents,
            affectedStudentIds: performance.failedStudentIds,
            severity: severity,
            recommendation: recommendation,
          ),
        );
      }
    }

    // ترتيب حسب الخطورة ثم معدل الفشل
    gaps.sort((a, b) {
      final severityCompare = b.severity.index.compareTo(a.severity.index);

      if (severityCompare != 0) return severityCompare;
      return b.failureRate.compareTo(a.failureRate);
    });

    return gaps;
  }

  /// تحليل الفجوات على مستوى المدرسة/المؤسسة
  Future<List<CurriculumGap>> analyzeGapsForInstitution({
    required List<QuizResult> allQuizResults,
    double failureThreshold = defaultFailureThreshold,
  }) async {
    // نفس المنطق لكن على مستوى جميع الفصول
    return await analyzeGapsForClass(
      classId: 'all',
      quizResults: allQuizResults,
      failureThreshold: failureThreshold,
    );
  }

  /// حساب درجة الخطورة
  GapSeverity _calculateSeverity(double failureRate) {
    if (failureRate >= 0.60) return GapSeverity.critical;
    if (failureRate >= 0.40) return GapSeverity.high;
    if (failureRate >= 0.30) return GapSeverity.medium;
    return GapSeverity.low;
  }

  /// توليد توصيات بناءً على التحليل
  String _generateRecommendation({
    required String unit,
    required String chapter,
    required double failureRate,
    required double averageScore,
  }) {
    final failurePercent = (failureRate * 100).toStringAsFixed(0);

    if (failureRate >= 0.60) {
      return '''
📌 خطورة عالية: $failurePercent% من الطلاب يفشلون

التوصيات العاجلة:
• إعادة شرح الوحدة بالكامل بطريقة مختلفة
• تقسيم الوحدة إلى أجزاء أصغر
• إضافة أمثلة عملية وتطبيقات واقعية
• تخصيص حصص دعم إضافية
• استخدام وسائل تعليمية مساعدة (فيديوهات، أنشطة)
''';
    } else if (failureRate >= 0.40) {
      return '''
⚠️ يحتاج تدخل: $failurePercent% من الطلاب يفشلون

التوصيات:
• مراجعة شاملة للموضوع
• إضافة تمارين تطبيقية أكثر
• تحديد الطلاب المتعثرين لدعم فردي
• اختبار قصير تشخيصي لتحديد نقاط الضعف
''';
    } else {
      return '''
✓ يحتاج متابعة: $failurePercent% من الطلاب يفشلون

التوصيات:
• مراجعة سريعة للنقاط الصعبة
• واجبات إضافية للتقوية
• متابعة الطلاب المتعثرين
''';
    }
  }

  /// إنشاء تنبيه للمعلم عن فجوة حرجة
  Future<void> notifyTeacherAboutGap(CurriculumGap gap) async {
    // TODO: إضافة نظام الإشعارات الفعلي
    // يمكنك إضافة هذا لاحقاً مع الـ Notification System

    print('''
🚨 تنبيه: فجوة منهجية حرجة
الوحدة: ${gap.unit}
الفصل: ${gap.chapter}

معدل الفشل: ${(gap.failureRate * 100).toStringAsFixed(0)}%
الطلاب المتأثرون: ${gap.failedStudents}/${gap.totalStudents}
''');
  }

  /// إحصائيات عامة عن الفجوات
  Future<Map<String, dynamic>> getGapStatistics(
    List<CurriculumGap> gaps,
  ) async {
    if (gaps.isEmpty) {
      return {
        'totalGaps': 0,
        'criticalGaps': 0,
        'highGaps': 0,
        'mediumGaps': 0,
        'lowGaps': 0,
        'averageFailureRate': 0.0,
      };
    }

    final critical = gaps
        .where((g) => g.severity == GapSeverity.critical)
        .length;
    final high = gaps.where((g) => g.severity == GapSeverity.high).length;
    final medium = gaps.where((g) => g.severity == GapSeverity.medium).length;
    final low = gaps.where((g) => g.severity == GapSeverity.low).length;

    final avgFailureRate =
        gaps.fold<double>(0.0, (sum, gap) => sum + gap.failureRate) /
        gaps.length;

    return {
      'totalGaps': gaps.length,
      'criticalGaps': critical,
      'highGaps': high,
      'mediumGaps': medium,
      'lowGaps': low,
      'averageFailureRate': avgFailureRate,
      'mostAffectedUnit': gaps.first.unit,
      'mostAffectedChapter': gaps.first.chapter,
    };
  }
}
