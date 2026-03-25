class QuestionOption {
  final String id;
  final String text;
  final bool isCorrect;

  QuestionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) => QuestionOption(
    id: json['id'],
    text: json['text'],
    isCorrect: json['isCorrect'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCorrect': isCorrect,
  };
}

class QuestionModel {
  final String id;
  final String questionText;
  final String questionType;
  final List<QuestionOption> options;
  final String correctAnswer;
  final String explanation;
  final String difficulty;
  final String cognitiveSkill;
  final String subject;
  final String subjectId; // ✅ جديد
  final String chapter;
  final String unit;
  final String? createdByTeacherName; // ✅ جديد — اسم المنشئ

  // إحصائيات الاستخدام
  final int timesUsed;
  final int timesCorrect;
  final int timesIncorrect;

  // مؤشرات الجودة
  final double difficultyIndex;
  final double discriminationIndex;
  final String quality;
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
    this.subjectId = '',
    required this.chapter,
    required this.unit,
    this.createdByTeacherName,
    this.timesUsed = 0,
    this.timesCorrect = 0,
    this.timesIncorrect = 0,
    this.difficultyIndex = 0.5,
    this.discriminationIndex = 0.3,
    this.quality = 'مقبول',
    this.isApproved = false,
    required this.createdAt,
  });

  // ── نسبة النجاح المحسوبة ──────────────────────────────────
  double get successRate {
    final total = timesCorrect + timesIncorrect;
    if (total == 0) return 0;
    return timesCorrect / total;
  }

  // ══════════════════════════════════════════════════════════════
  // ✅ fromRpcRow — من get_teacher_questions_with_stats
  // ══════════════════════════════════════════════════════════════
  factory QuestionModel.fromRpcRow(Map<String, dynamic> row) {
    // تحويل question_options من JSONB (Map) إلى List<QuestionOption>
    final opts = row['question_options'];
    List<QuestionOption> optionList = [];
    if (opts is Map) {
      int i = 0;
      opts.forEach((key, value) {
        optionList.add(
          QuestionOption(
            id: key.toString(),
            text: value.toString(),
            isCorrect:
                value.toString() == (row['correct_answer']?.toString() ?? ''),
          ),
        );
        i++;
      });
    } else if (opts is List) {
      for (var i = 0; i < opts.length; i++) {
        final o = opts[i];
        if (o is Map) {
          final m = Map<String, dynamic>.from(o);
          optionList.add(
            QuestionOption(
              id: 'O$i',
              text: m['text']?.toString() ?? '',
              isCorrect:
                  (row['correct_answer']?.toString() ?? '') ==
                  (m['text']?.toString() ?? ''),
            ),
          );
        }
      }
    }

    final qType = row['question_type']?.toString() ?? 'multiple_choice';
    final typeStr = qType == 'multiple_choice'
        ? 'mcq'
        : (qType == 'true_false' ? 'true_false' : qType);

    return QuestionModel(
      id: row['id']?.toString() ?? '',
      questionText: row['question_text']?.toString() ?? '',
      questionType: typeStr,
      options: optionList,
      correctAnswer: row['correct_answer']?.toString() ?? '',
      explanation: '',
      difficulty: row['difficulty_level']?.toString() ?? 'medium',
      cognitiveSkill: row['skill']?.toString() ?? '',
      subject: row['subject_name']?.toString() ?? '',
      subjectId: row['subject_id']?.toString() ?? '',
      chapter: '',
      unit: '',
      createdByTeacherName: row['teacher_name']?.toString(),
      timesUsed: (row['times_used'] as num?)?.toInt() ?? 0,
      timesCorrect: (row['times_correct'] as num?)?.toInt() ?? 0,
      timesIncorrect: (row['times_incorrect'] as num?)?.toInt() ?? 0,
      difficultyIndex: 0.5,
      discriminationIndex: 0.3,
      quality: row['quality']?.toString() ?? 'لم يُستخدم بعد',
      isApproved: true,
      createdAt: DateTime.now(),
    );
  }

  // ── fromQuestionRow (موجود مسبقاً — لا تعديل) ─────────────
  factory QuestionModel.fromQuestionRow(
    Map<String, dynamic> row, {
    String? subjectName,
  }) {
    final opts = row['question_options'];
    List<QuestionOption> optionList = [];
    if (opts is List) {
      for (var i = 0; i < opts.length; i++) {
        final o = opts[i];
        if (o is Map) {
          final m = Map<String, dynamic>.from(o);
          optionList.add(
            QuestionOption(
              id: 'O$i',
              text: m['text']?.toString() ?? '',
              isCorrect:
                  (row['correct_answer']?.toString() ?? '') ==
                  (m['text']?.toString() ?? ''),
            ),
          );
        }
      }
    }
    final subName =
        subjectName ??
        (row['subjects'] is Map
            ? (row['subjects'] as Map)['name']?.toString()
            : null) ??
        '';
    final qType = row['question_type']?.toString() ?? 'multiple_choice';
    final typeStr = qType == 'multiple_choice'
        ? 'mcq'
        : (qType == 'true_false' ? 'true_false' : qType);
    return QuestionModel(
      id: (row['id']?.toString() ?? ''),
      questionText: (row['question_text']?.toString() ?? ''),
      questionType: typeStr,
      options: optionList,
      correctAnswer: (row['correct_answer']?.toString() ?? ''),
      explanation: (row['explanation']?.toString() ?? ''),
      difficulty: (row['difficulty_level']?.toString() ?? 'medium'),
      cognitiveSkill: (row['skill']?.toString() ?? 'understand'),
      subject: subName,
      subjectId: row['subject_id']?.toString() ?? '',
      chapter: '',
      unit: '',
      timesUsed: (row['times_used'] is int)
          ? row['times_used'] as int
          : int.tryParse(row['times_used']?.toString() ?? '0') ?? 0,
      timesCorrect: (row['times_correct'] is int)
          ? row['times_correct'] as int
          : int.tryParse(row['times_correct']?.toString() ?? '0') ?? 0,
      timesIncorrect: (row['times_incorrect'] is int)
          ? row['times_incorrect'] as int
          : int.tryParse(row['times_incorrect']?.toString() ?? '0') ?? 0,
      difficultyIndex: (row['difficulty_index'] is num)
          ? (row['difficulty_index'] as num).toDouble()
          : 0.5,
      discriminationIndex: (row['discrimination_index'] is num)
          ? (row['discrimination_index'] as num).toDouble()
          : 0.3,
      quality: (row['quality']?.toString() ?? 'مقبول'),
      isApproved: (row['status']?.toString() ?? '') == 'approved',
      createdAt: row['created_at'] != null
          ? (DateTime.tryParse(row['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionText': questionText,
    'questionType': questionType,
    'options': options.map((e) => e.toJson()).toList(),
    'correctAnswer': correctAnswer,
    'explanation': explanation,
    'difficulty': difficulty,
    'cognitiveSkill': cognitiveSkill,
    'subject': subject,
    'subjectId': subjectId,
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
