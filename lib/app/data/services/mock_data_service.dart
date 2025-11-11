import 'dart:math';
import '../models/teacher_model.dart';
import '../models/class_model.dart';
import '../models/student_model.dart';
import '../models/question_model.dart';
import '../models/notification_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final Random _random = Random();

  // Current Teacher
  TeacherModel getCurrentTeacher() {
    return TeacherModel(
      id: 'T001',
      name: 'Amjed Essam',
      email: 'amjed.essam@school.com',
      phone: '774353045',
      subjects: ['الرياضيات'], // ✅ استبدال subject بـ subjects
      employeeId: '22',
      school: 'مدرسة النخبة الثانوية', // ✅ اختياري، لأنك أضفت الحقل الجديد
      profileImage: '👨‍🏫',
      totalStudents: 125,
      totalClasses: 4,
      averageScore: 82.5,
      joinedDate: DateTime(2023, 9, 1),
    );
  }

  // Classes
  List<ClassModel> getClasses() {
    return [
      ClassModel(
        id: 'C001',
        name: 'الصف الأول أ',
        subject: 'الرياضيات',
        grade: 'الأول الثانوي',
        totalStudents: 30,
        activeStudents: 28,
        averageScore: 85.2,
        totalQuizzes: 45,
        color: '0xFF6366F1',
        icon: '📘',
      ),
      ClassModel(
        id: 'C002',
        name: 'الصف الأول ب',
        subject: 'الرياضيات',
        grade: 'الأول الثانوي',
        totalStudents: 32,
        activeStudents: 30,
        averageScore: 78.5,
        totalQuizzes: 42,
        color: '0xFF10B981',
        icon: '📗',
      ),
      ClassModel(
        id: 'C003',
        name: 'الصف الثاني أ',
        subject: 'الرياضيات',
        grade: 'الثاني الثانوي',
        totalStudents: 28,
        activeStudents: 27,
        averageScore: 81.3,
        totalQuizzes: 38,
        color: '0xFFF59E0B',
        icon: '📙',
      ),
      ClassModel(
        id: 'C004',
        name: 'الصف الثاني ب',
        subject: 'الرياضيات',
        grade: 'الثاني الثانوي',
        totalStudents: 35,
        activeStudents: 33,
        averageScore: 76.8,
        totalQuizzes: 40,
        color: '0xFFEC4899',
        icon: '📕',
      ),
    ];
  }

  // Students
  List<StudentModel> getStudents({String? classId}) {
    final allStudents = [
      // الصف الأول أ
      _createStudent(
        'S001',
        'عبدالله أحمد',
        'C001',
        'الصف الأول أ',
        92.5,
        'Mastered',
      ),
      _createStudent(
        'S002',
        'نور محمد',
        'C001',
        'الصف الأول أ',
        88.3,
        'Proficient',
      ),
      _createStudent(
        'S003',
        'ليان خالد',
        'C001',
        'الصف الأول أ',
        85.7,
        'Proficient',
      ),
      _createStudent(
        'S004',
        'محمد علي',
        'C001',
        'الصف الأول أ',
        78.2,
        'Developing',
      ),
      _createStudent(
        'S005',
        'منار سعد',
        'C001',
        'الصف الأول أ',
        95.1,
        'Mastered',
      ),
      _createStudent(
        'S006',
        'يوسف حسن',
        'C001',
        'الصف الأول أ',
        82.4,
        'Proficient',
      ),
      _createStudent(
        'S007',
        'مريم عبدالله',
        'C001',
        'الصف الأول أ',
        90.8,
        'Mastered',
      ),
      _createStudent(
        'S008',
        'خالد سالم',
        'C001',
        'الصف الأول أ',
        75.3,
        'Developing',
      ),

      // الصف الأول ب
      _createStudent(
        'S009',
        'أحمد عمر',
        'C002',
        'الصف الأول ب',
        81.5,
        'Proficient',
      ),
      _createStudent(
        'S010',
        'ليلى محمود',
        'C002',
        'الصف الأول ب',
        76.8,
        'Developing',
      ),
      _createStudent(
        'S011',
        'عمر فهد',
        'C002',
        'الصف الأول ب',
        88.9,
        'Proficient',
      ),
      _createStudent(
        'S012',
        'هند عبدالرحمن',
        'C002',
        'الصف الأول ب',
        92.3,
        'Mastered',
      ),
      _createStudent(
        'S013',
        'طارق ناصر',
        'C002',
        'الصف الأول ب',
        68.5,
        'Needs Improvement',
      ),
      _createStudent(
        'S014',
        'دانة فيصل',
        'C002',
        'الصف الأول ب',
        85.2,
        'Proficient',
      ),

      // الصف الثاني أ
      _createStudent(
        'S015',
        'سلمان راشد',
        'C003',
        'الصف الثاني أ',
        87.6,
        'Proficient',
      ),
      _createStudent(
        'S016',
        'ريم صالح',
        'C003',
        'الصف الثاني أ',
        94.2,
        'Mastered',
      ),
      _createStudent(
        'S017',
        'فيصل حمد',
        'C003',
        'الصف الثاني أ',
        79.4,
        'Developing',
      ),
      _createStudent(
        'S018',
        'شهد عادل',
        'C003',
        'الصف الثاني أ',
        91.8,
        'Mastered',
      ),
    ];

    if (classId != null) {
      return allStudents.where((s) => s.classId == classId).toList();
    }
    return allStudents;
  }

  StudentModel _createStudent(
    String id,
    String name,
    String classId,
    String className,
    double avgScore,
    String mastery,
  ) {
    return StudentModel(
      id: id,
      name: name,
      email: '${name.replaceAll(' ', '.').toLowerCase()}@student.school.com',
      studentCode: 'STU${id.substring(1)}',
      classId: classId,
      className: className,
      profileImage: _random.nextBool() ? '👨‍🎓' : '👩‍🎓',
      averageScore: avgScore,
      totalQuizzes: 25 + _random.nextInt(15),
      completedQuizzes: 20 + _random.nextInt(10),
      masteryLevel: mastery,
      subjectPerformance: [
        SubjectPerformance(
          subjectName: 'الجبر',
          score: avgScore + _random.nextDouble() * 10 - 5,
          trend: _random.nextBool() ? 'up' : 'stable',
        ),
        SubjectPerformance(
          subjectName: 'الهندسة',
          score: avgScore + _random.nextDouble() * 10 - 5,
          trend: _random.nextBool() ? 'down' : 'stable',
        ),
        SubjectPerformance(
          subjectName: 'الإحصاء',
          score: avgScore + _random.nextDouble() * 10 - 5,
          trend: 'up',
        ),
      ],
      lastActive: DateTime.now().subtract(Duration(hours: _random.nextInt(48))),
    );
  }

  // Questions
  List<QuestionModel> getQuestions({
    String? difficulty,
    String? subject,
    String? chapter,
  }) {
    final allQuestions = [
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
        quality: 'Excellent',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      QuestionModel(
        id: 'Q002',
        questionText: 'حل المعادلة التربيعية: x² - 5x + 6 = 0',
        questionType: 'mcq',
        options: [
          QuestionOption(id: 'O1', text: 'x = 2, x = 3', isCorrect: true),
          QuestionOption(id: 'O2', text: 'x = 1, x = 6', isCorrect: false),
          QuestionOption(id: 'O3', text: 'x = -2, x = -3', isCorrect: false),
          QuestionOption(id: 'O4', text: 'x = 0, x = 5', isCorrect: false),
        ],
        correctAnswer: 'x = 2, x = 3',
        explanation: 'بالتحليل إلى عاملين: (x-2)(x-3) = 0',
        difficulty: 'medium',
        cognitiveSkill: 'analyze',
        subject: 'الرياضيات',
        chapter: 'الجبر',
        unit: 'المعادلات التربيعية',
        timesUsed: 98,
        timesCorrect: 62,
        timesIncorrect: 36,
        difficultyIndex: 0.63,
        discriminationIndex: 0.38,
        quality: 'Good',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      QuestionModel(
        id: 'Q003',
        questionText:
            'إذا كان محيط الدائرة 31.4 سم، فما هو نصف قطرها؟ (π = 3.14)',
        questionType: 'mcq',
        options: [
          QuestionOption(id: 'O1', text: '5 سم', isCorrect: true),
          QuestionOption(id: 'O2', text: '10 سم', isCorrect: false),
          QuestionOption(id: 'O3', text: '3 سم', isCorrect: false),
          QuestionOption(id: 'O4', text: '15 سم', isCorrect: false),
        ],
        correctAnswer: '5 سم',
        explanation: 'محيط الدائرة = 2πr، إذن: 31.4 = 2 × 3.14 × r، r = 5 سم',
        difficulty: 'medium',
        cognitiveSkill: 'apply',
        subject: 'الرياضيات',
        chapter: 'الهندسة',
        unit: 'الدوائر',
        timesUsed: 87,
        timesCorrect: 56,
        timesIncorrect: 31,
        difficultyIndex: 0.64,
        discriminationIndex: 0.42,
        quality: 'Excellent',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      QuestionModel(
        id: 'Q004',
        questionText: 'ما هي مساحة المثلث الذي طول قاعدته 8 سم وارتفاعه 6 سم؟',
        questionType: 'mcq',
        options: [
          QuestionOption(id: 'O1', text: '24 سم²', isCorrect: true),
          QuestionOption(id: 'O2', text: '48 سم²', isCorrect: false),
          QuestionOption(id: 'O3', text: '14 سم²', isCorrect: false),
          QuestionOption(id: 'O4', text: '32 سم²', isCorrect: false),
        ],
        correctAnswer: '24 سم²',
        explanation:
            'مساحة المثلث = ½ × القاعدة × الارتفاع = ½ × 8 × 6 = 24 سم²',
        difficulty: 'easy',
        cognitiveSkill: 'remember',
        subject: 'الرياضيات',
        chapter: 'الهندسة',
        unit: 'المثلثات',
        timesUsed: 156,
        timesCorrect: 142,
        timesIncorrect: 14,
        difficultyIndex: 0.91,
        discriminationIndex: 0.22,
        quality: 'Fair',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      QuestionModel(
        id: 'Q005',
        questionText: 'احسب قيمة: sin(30°) + cos(60°)',
        questionType: 'mcq',
        options: [
          QuestionOption(id: 'O1', text: '1', isCorrect: true),
          QuestionOption(id: 'O2', text: '0.5', isCorrect: false),
          QuestionOption(id: 'O3', text: '1.5', isCorrect: false),
          QuestionOption(id: 'O4', text: '0', isCorrect: false),
        ],
        correctAnswer: '1',
        explanation: 'sin(30°) = 0.5 و cos(60°) = 0.5، الجمع = 1',
        difficulty: 'hard',
        cognitiveSkill: 'analyze',
        subject: 'الرياضيات',
        chapter: 'حساب المثلثات',
        unit: 'الدوال المثلثية',
        timesUsed: 72,
        timesCorrect: 28,
        timesIncorrect: 44,
        difficultyIndex: 0.39,
        discriminationIndex: 0.51,
        quality: 'Excellent',
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    var filtered = allQuestions;

    if (difficulty != null) {
      filtered = filtered.where((q) => q.difficulty == difficulty).toList();
    }
    if (subject != null) {
      filtered = filtered.where((q) => q.subject == subject).toList();
    }
    if (chapter != null) {
      filtered = filtered.where((q) => q.chapter == chapter).toList();
    }

    return filtered;
  }

  // Notifications
  List<NotificationModel> getNotifications() {
    return [
      NotificationModel(
        id: 'N001',
        title: 'طالب أكمل اختباراً',
        message: 'أكمل الطالب عبدالله أحمد اختبار الجبر - الوحدة 3',
        type: 'quiz_completed',
        isRead: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        data: {'studentId': 'S001', 'quizId': 'QZ001'},
      ),
      NotificationModel(
        id: 'N002',
        title: 'تنبيه أداء ضعيف',
        message: 'الطالب طارق ناصر حصل على 45% في اختبار الهندسة',
        type: 'low_performance',
        isRead: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        data: {'studentId': 'S013', 'score': 45},
      ),
      NotificationModel(
        id: 'N003',
        title: 'طالب جديد',
        message: 'تم إضافة طالب جديد إلى الصف الأول أ',
        type: 'new_student',
        isRead: true,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'N004',
        title: 'تحديث النظام',
        message: 'تم تحديث نظام التقارير مع ميزات جديدة',
        type: 'system',
        isRead: true,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  // Dashboard Statistics
  Map<String, dynamic> getDashboardStats() {
    return {
      'totalStudents': 125,
      'activeStudents': 118,
      'totalClasses': 4,
      'averageScore': 82.5,
      'totalQuizzes': 165,
      'completedQuizzes': 152,
      'pendingQuestions': 8,
      'lowPerformanceStudents': 12,
      'weeklyProgress': [65, 72, 78, 85, 82, 88, 92], // آخر 7 أيام
      'subjectPerformance': [
        {'subject': 'الجبر', 'average': 85.2},
        {'subject': 'الهندسة', 'average': 78.5},
        {'subject': 'الإحصاء', 'average': 81.3},
        {'subject': 'حساب المثلثات', 'average': 76.8},
      ],
    };
  }
}
