/// نموذج نتيجة اختبار
class QuizResult {
  final String id;
  final String quizId;
  final String quizTitle;
  final String studentId;
  final double score; // نسبة مئوية 0-100
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;
  final Map<String, dynamic>? answers; // إجابات الطالب
  final String? feedback; // تعليق من المعلم

  QuizResult({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.studentId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
    this.answers,
    this.feedback,
  });

  /// إنشاء من JSON
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      quizTitle: json['quizTitle'] as String,
      studentId: json['studentId'] as String,
      score: (json['score'] as num).toDouble(),
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      answers: json['answers'] as Map<String, dynamic>?,
      feedback: json['feedback'] as String?,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'quizTitle': quizTitle,
      'studentId': studentId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'completedAt': completedAt.toIso8601String(),
      'answers': answers,
      'feedback': feedback,
    };
  }

  /// نسخ مع تعديل
  QuizResult copyWith({
    String? id,
    String? quizId,
    String? quizTitle,
    String? studentId,
    double? score,
    int? totalQuestions,
    int? correctAnswers,
    DateTime? completedAt,
    Map<String, dynamic>? answers,
    String? feedback,
  }) {
    return QuizResult(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      quizTitle: quizTitle ?? this.quizTitle,
      studentId: studentId ?? this.studentId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      completedAt: completedAt ?? this.completedAt,
      answers: answers ?? this.answers,
      feedback: feedback ?? this.feedback,
    );
  }
}