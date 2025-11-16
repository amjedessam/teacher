// import '../models/question_model.dart';

// /// Repository Pattern للأسئلة
// /// يفصل بين Business Logic و Data Source
// abstract class QuestionRepository {
//   /// جلب جميع الأسئلة مع فلاتر اختيارية
//   Future<List<QuestionModel>> getQuestions({
//     String? difficulty,
//     String? subject,
//     String? chapter,
//     String? unit,
//   });

//   /// جلب سؤال محدد بـ ID
//   Future<QuestionModel?> getQuestionById(String id);

//   /// إضافة سؤال جديد
//   Future<void> addQuestion(QuestionModel question);

//   /// تحديث سؤال موجود

//   Future<void> updateQuestion(QuestionModel question);

//   /// حذف سؤال
//   Future<void> deleteQuestion(String id);

//   /// تحديث إحصائيات السؤال بعد استخدامه
//   Future<void> updateQuestionStatistics({
//     required String questionId,
//     required bool wasCorrect,
//     required double studentTotalScore,
//   });

//   /// جلب أسئلة حسب الجودة
//   Future<List<QuestionModel>> getQuestionsByQuality(String quality);

//   /// جلب الأسئلة التي تحتاج مراجعة
//   Future<List<QuestionModel>> getSuspiciousQuestions();
// }

// /// Implementation باستخدام Mock Data (حالياً)
// /// ستستبدله أنت بـ API Implementation لاحقاً

// class QuestionRepositoryImpl implements QuestionRepository {
//   // TODO: استبدل بـ ApiProvider عند جاهزية الـ Backend
//   // final ApiProvider _api;

//   // Mock data source (مؤقت)
//   final List<QuestionModel> _mockQuestions = [];

//   QuestionRepositoryImpl() {
//     _initMockData();
//   }

//   void _initMockData() {
//     // تهيئة بيانات وهمية للتطوير
//     _mockQuestions.addAll([
//       QuestionModel(
//         id: 'Q001',
//         questionText: 'ما هي قيمة x في المعادلة: 2x + 5 = 15؟',
//         questionType: 'mcq',
//         options: [
//           QuestionOption(id: 'O1', text: '5', isCorrect: true),
//           QuestionOption(id: 'O2', text: '3', isCorrect: false),
//           QuestionOption(id: 'O3', text: '7', isCorrect: false),
//           QuestionOption(id: 'O4', text: '10', isCorrect: false),
//         ],
//         correctAnswer: '5',
//         explanation: 'بطرح 5 من الطرفين: 2x = 10، ثم القسمة على 2: x = 5',
//         difficulty: 'easy',
//         cognitiveSkill: 'apply',
//         subject: 'الرياضيات',
//         chapter: 'الجبر',
//         unit: 'المعادلات الخطية',
//         timesUsed: 145,
//         timesCorrect: 120,
//         timesIncorrect: 25,
//         difficultyIndex: 0.83,
//         discriminationIndex: 0.45,
//         quality: 'Excellent',
//         isApproved: true,

//         createdAt: DateTime.now().subtract(const Duration(days: 30)),
//       ),
//       // يمكن إضافة المزيد من البيانات الوهمية هنا
//     ]);
//   }

//   @override
//   Future<List<QuestionModel>> getQuestions({
//     String? difficulty,
//     String? subject,
//     String? chapter,
//     String? unit,
//   }) async {
//     // TODO: استبدل بـ API call
//     // final response = await _api.get('/questions', queryParams: {...});

//     await Future.delayed(
//       const Duration(milliseconds: 500),
//     ); // محاكاة network delay

//     var filtered = List<QuestionModel>.from(_mockQuestions);

//     if (difficulty != null) {
//       filtered = filtered.where((q) => q.difficulty == difficulty).toList();
//     }
//     if (subject != null) {
//       filtered = filtered.where((q) => q.subject == subject).toList();
//     }
//     if (chapter != null) {
//       filtered = filtered.where((q) => q.chapter == chapter).toList();
//     }
//     if (unit != null) {
//       filtered = filtered.where((q) => q.unit == unit).toList();
//     }

//     return filtered;
//   }

//   @override
//   Future<QuestionModel?> getQuestionById(String id) async {
//     // TODO: API call
//     await Future.delayed(const Duration(milliseconds: 300));

//     try {
//       return _mockQuestions.firstWhere((q) => q.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<void> addQuestion(QuestionModel question) async {
//     // TODO: API call
//     // await _api.post('/questions', body: question.toJson());

//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockQuestions.add(question);
//   }

//   @override
//   Future<void> updateQuestion(QuestionModel question) async {
//     // TODO: API call
//     // await _api.put('/questions/${question.id}', body: question.toJson());

//     await Future.delayed(const Duration(milliseconds: 500));

//     final index = _mockQuestions.indexWhere((q) => q.id == question.id);
//     if (index != -1) {
//       _mockQuestions[index] = question;
//     }
//   }

//   @override
//   Future<void> deleteQuestion(String id) async {
//     // TODO: API call
//     // await _api.delete('/questions/$id');

//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockQuestions.removeWhere((q) => q.id == id);
//   }

//   @override
//   Future<void> updateQuestionStatistics({
//     required String questionId,
//     required bool wasCorrect,
//     required double studentTotalScore,
//   }) async {
//     // TODO: API call لتحديث الإحصائيات
//     // await _api.patch('/questions/$questionId/statistics', body: {...});

//     await Future.delayed(const Duration(milliseconds: 300));

//     final index = _mockQuestions.indexWhere((q) => q.id == questionId);
//     if (index == -1) return;

//     final question = _mockQuestions[index];
//     final updatedQuestion = QuestionModel(
//       id: question.id,
//       questionText: question.questionText,
//       questionType: question.questionType,
//       options: question.options,
//       correctAnswer: question.correctAnswer,
//       explanation: question.explanation,
//       difficulty: question.difficulty,
//       cognitiveSkill: question.cognitiveSkill,
//       subject: question.subject,
//       chapter: question.chapter,
//       unit: question.unit,
//       timesUsed: question.timesUsed + 1,
//       timesCorrect: question.timesCorrect + (wasCorrect ? 1 : 0),
//       timesIncorrect: question.timesIncorrect + (wasCorrect ? 0 : 1),

//       difficultyIndex:
//           question.difficultyIndex, // سيتم حسابه في AnalysisService
//       discriminationIndex:
//           question.discriminationIndex, // سيتم حسابه في AnalysisService
//       quality: question.quality,
//       isApproved: question.isApproved,
//       createdAt: question.createdAt,
//     );

//     _mockQuestions[index] = updatedQuestion;
//   }

//   @override
//   Future<List<QuestionModel>> getQuestionsByQuality(String quality) async {
//     // TODO: API call
//     await Future.delayed(const Duration(milliseconds: 500));

//     return _mockQuestions.where((q) => q.quality == quality).toList();
//   }

//   @override
//   Future<List<QuestionModel>> getSuspiciousQuestions() async {
//     // TODO: API call
//     await Future.delayed(const Duration(milliseconds: 500));

//     // الأسئلة المشبوهة: DI < 0.3 أو DI > 0.9 أو DiscI < 0.2
//     return _mockQuestions.where((q) {
//       return q.difficultyIndex < 0.3 ||
//           q.difficultyIndex > 0.9 ||
//           q.discriminationIndex < 0.2;
//     }).toList();
//   }
// }

import '../models/question_model.dart';

/// Repository Pattern للأسئلة
/// يفصل بين Business Logic و Data Source
abstract class QuestionRepository {
  /// جلب جميع الأسئلة مع فلاتر اختيارية
  Future<List<QuestionModel>> getQuestions({
    String? difficulty,
    String? subject,
    String? chapter,
    String? unit,
  });

  /// جلب سؤال محدد بـ ID
  Future<QuestionModel?> getQuestionById(String id);

  /// إضافة سؤال جديد
  Future<void> addQuestion(QuestionModel question);

  /// تحديث سؤال موجود
  Future<void> updateQuestion(QuestionModel question);

  /// حذف سؤال
  Future<void> deleteQuestion(String id);

  /// تحديث إحصائيات السؤال بعد استخدامه
  Future<void> updateQuestionStatistics({
    required String questionId,
    required bool wasCorrect,
    required double studentTotalScore,
  });

  /// جلب أسئلة حسب الجودة
  Future<List<QuestionModel>> getQuestionsByQuality(String quality);

  /// جلب الأسئلة التي تحتاج مراجعة
  Future<List<QuestionModel>> getSuspiciousQuestions();
}

/// Implementation باستخدام Mock Data (حالياً)
class QuestionRepositoryImpl implements QuestionRepository {
  // Mock data source (مؤقت)
  final List<QuestionModel> _mockQuestions = [];

  QuestionRepositoryImpl() {
    _initMockData();
  }

  void _initMockData() {
    // تهيئة بيانات وهمية للتطوير
    _mockQuestions.addAll([
      QuestionModel(
        id: 'Q001',
        questionText: 'ما هي قيمة x في المعادلة: 2x + 5 = 15؟',
        questionType: 'mcq',
        options: [
          QuestionOption(id: 'O1', text: '5', isCorrect: true),
          QuestionOption(id: 'O2', text: '3', isCorrect: false),
          QuestionOption(id: 'O3', text: '7', isCorrect: false),
          QuestionOption(id: 'O4', text: '10', isCorrect: false),
        ],
        correctAnswer: '5',
        explanation: 'بطرح 5 من الطرفين: 2x = 10، ثم القسمة على 2: x = 5',
        difficulty: 'easy',
        cognitiveSkill: 'apply',
        subject: 'الرياضيات',
        chapter: 'الجبر',
        unit: 'المعادلات الخطية',
        timesUsed: 145,
        timesCorrect: 120,
        timesIncorrect: 25,
        difficultyIndex: 0.83,
        discriminationIndex: 0.45,
        quality: 'ممتاز',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      QuestionModel(
        id: 'Q002',
        questionText: 'أي من الخيارات التالية يمثل عاصمة فرنسا؟',
        questionType: 'mcq',
        options: [
          QuestionOption(id: 'O1', text: 'لندن', isCorrect: false),
          QuestionOption(id: 'O2', text: 'باريس', isCorrect: true),
          QuestionOption(id: 'O3', text: 'روما', isCorrect: false),
          QuestionOption(id: 'O4', text: 'برلين', isCorrect: false),
        ],
        correctAnswer: 'باريس',
        explanation: 'باريس هي عاصمة فرنسا.',
        difficulty: 'easy',
        cognitiveSkill: 'remember',
        subject: 'الجغرافيا',
        chapter: 'أوروبا',
        unit: 'العواصم',
        timesUsed: 200,
        timesCorrect: 195,
        timesIncorrect: 5,
        difficultyIndex: 0.975,
        discriminationIndex: 0.10,
        quality: 'يحتاج مراجعة', // سهل جداً ولا يميز
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
      ),
      QuestionModel(
        id: 'Q003',
        questionText: 'اشرح مبدأ عمل المحرك الحراري في أربع خطوات.',
        questionType: 'essay',
        options: [],
        correctAnswer: 'شرح مبدأ عمل المحرك الحراري',
        explanation: 'يجب أن يشمل الشرح: سحب الحرارة، التمدد، الدفع، الطرد.',
        difficulty: 'hard',
        cognitiveSkill: 'analyze',
        subject: 'الفيزياء',
        chapter: 'الديناميكا الحرارية',
        unit: 'المحركات',
        timesUsed: 50,
        timesCorrect: 15,
        timesIncorrect: 35,
        difficultyIndex: 0.30,
        discriminationIndex: 0.25,
        quality: 'مقبول',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ]);
  }

  @override
  Future<List<QuestionModel>> getQuestions({
    String? difficulty,
    String? subject,
    String? chapter,
    String? unit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var filtered = List<QuestionModel>.from(_mockQuestions);
    // منطق الفلترة
    return filtered;
  }

  @override
  Future<QuestionModel?> getQuestionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockQuestions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addQuestion(QuestionModel question) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockQuestions.add(question);
  }

  @override
  Future<void> updateQuestion(QuestionModel question) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockQuestions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _mockQuestions[index] = question;
    }
  }

  @override
  Future<void> deleteQuestion(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockQuestions.removeWhere((q) => q.id == id);
  }

  @override
  Future<void> updateQuestionStatistics({
    required String questionId,
    required bool wasCorrect,
    required double studentTotalScore,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockQuestions.indexWhere((q) => q.id == questionId);
    if (index == -1) return;

    final question = _mockQuestions[index];
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
      timesUsed: question.timesUsed + 1,
      timesCorrect: question.timesCorrect + (wasCorrect ? 1 : 0),
      timesIncorrect: question.timesIncorrect + (wasCorrect ? 0 : 1),
      difficultyIndex: question.difficultyIndex,
      discriminationIndex: question.discriminationIndex,
      quality: question.quality,
      isApproved: question.isApproved,
      createdAt: question.createdAt,
    );
    _mockQuestions[index] = updatedQuestion;
  }

  @override
  Future<List<QuestionModel>> getQuestionsByQuality(String quality) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockQuestions.where((q) => q.quality == quality).toList();
  }

  @override
  Future<List<QuestionModel>> getSuspiciousQuestions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // الأسئلة المشبوهة: DI > 0.9 أو DI < 0.3 أو DiscI < 0.2
    return _mockQuestions.where((q) {
      return q.difficultyIndex < 0.3 ||
          q.difficultyIndex > 0.9 ||
          q.discriminationIndex < 0.2;
    }).toList();
  }
}
