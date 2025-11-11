class QuestionModel {
  final String id;
  final String questionText;
  final String questionType; // mcq, true_false, fill_blank
  final List<QuestionOption> options;
  final String correctAnswer;
  final String explanation;
  final String difficulty; // easy, medium, hard
  final String cognitiveSkill; // remember, understand, apply, analyze
  final String subject;
  final String chapter;
  final String unit;
  final int timesUsed;
  final int timesCorrect;
  final int timesIncorrect;
  final double difficultyIndex;
  final double discriminationIndex;
  final String quality; // Excellent, Good, Fair, Poor
  final bool isApproved;
  final DateTime createdAt;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
    required this.cognitiveSkill,
    required this.subject,
    required this.chapter,
    required this.unit,
    required this.timesUsed,
    required this.timesCorrect,
    required this.timesIncorrect,
    required this.difficultyIndex,
    required this.discriminationIndex,
    required this.quality,
    required this.isApproved,
    required this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? '',
      questionText: json['questionText'] ?? '',
      questionType: json['questionType'] ?? 'mcq',
      options:
          (json['options'] as List?)
              ?.map((e) => QuestionOption.fromJson(e))
              .toList() ??
          [],
      correctAnswer: json['correctAnswer'] ?? '',
      explanation: json['explanation'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      cognitiveSkill: json['cognitiveSkill'] ?? 'understand',
      subject: json['subject'] ?? '',
      chapter: json['chapter'] ?? '',
      unit: json['unit'] ?? '',
      timesUsed: json['timesUsed'] ?? 0,
      timesCorrect: json['timesCorrect'] ?? 0,
      timesIncorrect: json['timesIncorrect'] ?? 0,
      difficultyIndex: (json['difficultyIndex'] ?? 0.5).toDouble(),
      discriminationIndex: (json['discriminationIndex'] ?? 0.3).toDouble(),
      quality: json['quality'] ?? 'Good',
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'questionType': questionType,
      'options': options.map((e) => e.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'difficulty': difficulty,
      'cognitiveSkill': cognitiveSkill,
      'subject': subject,
      'chapter': chapter,
      'unit': unit,
      'timesUsed': timesUsed,
      'timesCorrect': timesCorrect,
      'timesIncorrect': timesIncorrect,
      'difficultyIndex': difficultyIndex,
      'discriminationIndex': discriminationIndex,
      'quality': quality,
      'isApproved': isApproved,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class QuestionOption {
  final String id;
  final String text;
  final bool isCorrect;

  QuestionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isCorrect': isCorrect};
  }
}
