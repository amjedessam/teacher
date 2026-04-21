import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum GapSeverity { critical, high, medium, low }

class QuestionGap {
  final String questionText;
  final int totalStudents;
  final int failedStudents;
  final double failureRate;
  final GapSeverity severity;

  QuestionGap({
    required this.questionText,
    required this.totalStudents,
    required this.failedStudents,
    required this.failureRate,
    required this.severity,
  });

  // من كائن إلى JSON لإرساله للـ AI كبيانات خام
  Map<String, dynamic> toJson() => {
    'question_text': questionText,
    'total_students': totalStudents,
    'failed_students': failedStudents,
    'failure_rate': failureRate,
    'severity': severity.name,
  };

  // من JSON إلى كائن (إذا قرر الـ AI تصنيف كل سؤال على حدة)
  factory QuestionGap.fromJson(Map<String, dynamic> json) => QuestionGap(
    questionText: json['question_text'] ?? '',
    totalStudents: json['total_students'] ?? 0,
    failedStudents: json['failed_students'] ?? 0,
    failureRate: (json['failure_rate'] as num).toDouble(),
    severity: GapSeverity.values.byName(json['severity'] ?? 'low'),
  );
}
class ChapterGap {
  final String id;
  final String chapterName;
  final String subjectName;
  final double avgFailureRate;
  final GapSeverity severity;
  final String recommendation;
  final List<QuestionGap> questions;
  final RxBool isExpanded = false.obs;

  ChapterGap({
    required this.id,
    required this.chapterName,
    required this.subjectName,
    required this.avgFailureRate,
    required this.severity,
    required this.recommendation,
    required this.questions,
  });

  // تحويل البيانات لإرسالها للذكاء الاصطناعي للتحليل
  Map<String, dynamic> toJson() => {
    'id': id,
    'chapter_name': chapterName,
    'subject_name': subjectName,
    'avg_failure_rate': avgFailureRate,
    'severity': severity.name,
    'questions': questions.map((q) => q.toJson()).toList(),
    // ملاحظة: لا نرسل التوصية أو isExpanded لأننا نطلب التوصية من الـ AI أصلاً
  };

  // استقبال تحليل الذكاء الاصطناعي وتحويله لبطاقات عرض
  factory ChapterGap.fromJson(Map<String, dynamic> json) {
    return ChapterGap(
      id: json['id']?.toString() ?? '',
      chapterName: json['chapter_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      avgFailureRate: (json['avg_failure_rate'] as num?)?.toDouble() ?? 0.0,
      severity: GapSeverity.values.byName(json['severity'] ?? 'low'),
      recommendation: json['ai_recommendation'] ?? 'لا توجد توصيات حالياً', // الحقل القادم من الـ AI
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuestionGap.fromJson(q))
          .toList(),
    );
  }
}
