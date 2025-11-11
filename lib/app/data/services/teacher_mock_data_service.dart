// import '../models/student_model.dart';
// import '../models/class_model.dart';
// import '../models/question_quality_model.dart';
// import '../models/report_model.dart';
// import '../models/notification_model.dart';
// import '../models/user_model.dart';

// class TeacherMockDataService {
//   /// الحصول على بيانات المعلم الحالي
//   static UserModel getMockTeacher() {
//     return UserModel(
//       id: 't1',
//       name: 'أ. محمد علي',
//       email: 'teacher@example.com',
//       avatar: 'https://ui-avatars.com/api/?name=Teacher&background=FF6B6B&color=fff',
//       createdAt: DateTime.now().subtract(const Duration(days: 365)),
//     );
//   }

//   /// الحصول على الفصول المخصصة للمعلم
//   static List<ClassModel> getMockClasses() {
//     return [
//       ClassModel(
//         id: 'class_1',
//         name: 'الفصل الأول - أ',
//         teacherId: 't1',
//         description: 'فصل الصف الأول الثانوي',
//         studentCount: 35,
//         averageScore: 78.5,
//         attendanceRate: 0.92,
//         createdAt: DateTime.now().subtract(const Duration(days: 180)),
//         studentIds: ['s1', 's2', 's3', 's4', 's5'],
//         academicYear: '2024-2025',
//         gradeLevel: 'الأول الثانوي',
//       ),
//       ClassModel(
//         id: 'class_2',
//         name: 'الفصل الثاني - ب',
//         teacherId: 't1',
//         description: 'فصل الصف الأول الثانوي',
//         studentCount: 32,
//         averageScore: 75.2,
//         attendanceRate: 0.88,
//         createdAt: DateTime.now().subtract(const Duration(days: 180)),
//         studentIds: ['s6', 's7', 's8', 's9', 's10'],
//         academicYear: '2024-2025',
//         gradeLevel: 'الأول الثانوي',
//       ),
//     ];
//   }

//   /// الحصول على الطلاب في فصل معين
//   static List<StudentModel> getMockStudentsByClass(String classId) {
//     final allStudents = [
//       StudentModel(
//         id: 's1',
//         name: 'أحمد محمود',
//         email: 'ahmed@example.com',
//         avatar: 'https://ui-avatars.com/api/?name=Ahmed&background=4CAF50&color=fff',
//         createdAt: DateTime.now().subtract(const Duration(days: 180)),
//         classId: 'class_1',
//         studentId: '001',
//         overallMastery: 85.5,
//         masteryBySkill: {
//           'تذكر': 90.0,
//           'فهم': 85.0,
//           'تطبيق': 80.0,
//           'تحليل': 75.0,
//         },
//         quizHistory: [
//           StudentQuizHistory(
//             quizId: 'qz1',
//             quizName: 'اختبار الوحدة الأولى',
//             score: 85,
//             totalQuestions: 100,
//             percentage: 85.0,
//             completedAt: DateTime.now().subtract(const Duration(days: 7)),
//             skillMastery: {'تذكر': 90.0, 'فهم': 85.0},
//           ),
//         ],
//         enrolledAt: DateTime.now().subtract(const Duration(days: 180)),
//         isActive: true,
//       ),
//       StudentModel(
//         id: 's2',
//         name: 'فاطمة علي',
//         email: 'fatima@example.com',
//         avatar: 'https://ui-avatars.com/api/?name=Fatima&background=2196F3&color=fff',
//         createdAt: DateTime.now().subtract(const Duration(days: 180)),
//         classId: 'class_1',
//         studentId: '002',
//         overallMastery: 72.0,
//         masteryBySkill: {
//           'تذكر': 80.0,
//           'فهم': 70.0,
//           'تطبيق': 65.0,
//           'تحليل': 60.0,
//         },
//         quizHistory: [
//           StudentQuizHistory(
//             quizId: 'qz1',
//             quizName: 'اختبار الوحدة الأولى',
//             score: 72,
//             totalQuestions: 100,
//             percentage: 72.0,
//             completedAt: DateTime.now().subtract(const Duration(days: 10)),
//             skillMastery: {'تذكر': 80.0, 'فهم': 70.0},
//           ),
//         ],
//         enrolledAt: DateTime.now().subtract(const Duration(days: 180)),
//         isActive: true,
//       ),
//       StudentModel(
//         id: 's3',
//         name: 'محمد سالم',
//         email: 'salem@example.com',
//         avatar: 'https://ui-avatars.com/api/?name=Salem&background=FF9800&color=fff',
//         createdAt: DateTime.now().subtract(const Duration(days: 180)),
//         classId: 'class_1',
//         studentId: '003',
//         overallMastery: 58.0,
//         masteryBySkill: {
//           'تذكر': 65.0,
//           'فهم': 55.0,
//           'تطبيق': 50.0,
//           'تحليل': 45.0,
//         },
//         quizHistory: [
//           StudentQuizHistory(
//             quizId: 'qz1',
//             quizName: 'اختبار الوحدة الأولى',
//             score: 58,
//             totalQuestions: 100,
//             percentage: 58.0,
//             completedAt: DateTime.now().subtract(const Duration(days: 14)),
//             skillMastery: {'تذكر': 65.0, 'فهم': 55.0},
//           ),
//         ],
//         enrolledAt: DateTime.now().subtract(const Duration(days: 180)),
//         isActive: true,
//       ),
//     ];

//     return allStudents.where((s) => s.classId == classId).toList();
//   }

//   /// الحصول على تحليل جودة الأسئلة
//   static List<QuestionQualityModel> getMockQuestionQualities() {
//     return [
//       QuestionQualityModel(
//         questionId: 'q1',
//         questionText: 'ما هي عاصمة فرنسا؟',
//         type: 'اختيار من متعدد',
//         unit: 'الوحدة الأولى',
//         skill: 'تذكر',
//         difficulty: 'سهل',
//         usageCount: 45,
//         correctRate: 0.78,
//         difficultyIndex: 0.78,
//         discriminationIndex: 0.35,
//         qualityLabel: 'جيد',
//         isSuspicious: false,
//         lastUpdated: DateTime.now(),
//       ),
//       QuestionQualityModel(
//         questionId: 'q2',
//         questionText: 'حلل العوامل المؤثرة على...',
//         type: 'اختيار من متعدد',
//         unit: 'الوحدة الثانية',
//         skill: 'تحليل',
//         difficulty: 'متوسط',
//         usageCount: 32,
//         correctRate: 0.25,
//         difficultyIndex: 0.25,
//         discriminationIndex: 0.15,
//         qualityLabel: 'يحتاج مراجعة',
//         isSuspicious: true,
//         lastUpdated: DateTime.now(),
//       ),
//       QuestionQualityModel(
//         questionId: 'q3',
//         questionText: 'أي من الخيارات التالية صحيح؟',
//         type: 'صح/خطأ',
//         unit: 'الوحدة الأولى',
//         skill: 'فهم',
//         difficulty: 'سهل',
//         usageCount: 60,
//         correctRate: 0.92,
//         difficultyIndex: 0.92,
//         discriminationIndex: 0.25,
//         qualityLabel: 'يحتاج مراجعة',
//         isSuspicious: true,
//         lastUpdated: DateTime.now(),
//       ),
//     ];
//   }

//   /// الحصول على تقرير الطالب
//   static StudentReportModel getMockStudentReport(String studentId) {
//     return StudentReportModel(
//       studentId: studentId,
//       studentName: 'أحمد محمود',
//       masteryPerSkill: {
//         'تذكر': 90.0,
//         'فهم': 85.0,
//         'تطبيق': 80.0,
//         'تحليل': 75.0,
//       },
//       strengthsAndWeaknesses: [
//         SkillStrengthWeakness(
//           skill: 'تذكر',
//           masteryLevel: 90.0,
//           isStrength: true,
//         ),
//         SkillStrengthWeakness(
//           skill: 'تحليل',
//           masteryLevel: 75.0,
//           isStrength: false,
//         ),
//       ],
//       quizAttempts: [
//         QuizAttempt(
//           quizId: 'qz1',
//           quizName: 'اختبار الوحدة الأولى',
//           score: 85,
//           totalQuestions: 100,
//           percentage: 85.0,
//           attemptDate: DateTime.now().subtract(const Duration(days: 7)),
//         ),
//       ],
//       recommendations: [
//         'التركيز على تحسين مهارات التحليل',
//         'حل مزيد من التطبيقات العملية',
//         'مراجعة الوحدة الثالثة',
//       ],
//       overallProgress: 82.5,
//       generatedAt: DateTime.now(),
//     );
//   }

//   /// الحصول على تقرير الفصل
//   static ClassReportModel getMockClassReport(String classId) {
//     return ClassReportModel(
//       classId: classId,
//       className: 'الفصل الأول - أ',
//       totalStudents: 35,
//       classAverageScore: 78.5,
//       averageScorePerUnit: {
//         'الوحدة الأولى': 82.0,
//         'الوحدة الثانية': 76.0,
//         'الوحدة الثالثة': 75.0,
//       },
//       studentPerformances: [
//         StudentPerformance(
//           studentId: 's1',
//           studentName: 'أحمد محمود',
//           averageScore: 85.0,
//           quizzesCompleted: 5,
//           masteryLevel: 85.5,
//         ),
//         StudentPerformance(
//           studentId: 's2',
//           studentName: 'فاطمة علي',
//           averageScore: 72.0,
//           quizzesCompleted: 4,
//           masteryLevel: 72.0,
//         ),
//       ],
//       strugglingStudents: ['s3', 's4'],
//       completionRate: 0.85,
//       generatedAt: DateTime.now(),
//     );
//   }

//   /// الحصول على الإشعارات
//   static List<NotificationModel> getMockNotifications() {
//     return [
//       NotificationModel(
//         id: 'notif_1',
//         title: 'تحذير: طالب يحتاج مساعدة',
//         message: 'الطالب محمد سالم حقق نسبة فشل أكثر من 40%',
//         type: 'warning',
//         relatedEntityId: 's3',
//         relatedEntityType: 'student',
//         createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//         isRead: false,
//       ),
//       NotificationModel(
//         id: 'notif_2',
//         title: 'سؤال مشبوه',
//         message: 'السؤال "ما هي عاصمة فرنسا؟" يحتاج مراجعة - نسبة الإجابة الصحيحة 92%',
//         type: 'info',
//         relatedEntityId: 'q3',
//         relatedEntityType: 'question',
//         createdAt: DateTime.now().subtract(const Duration(hours: 5)),
//         isRead: false,
//       ),
//       NotificationModel(
//         id: 'notif_3',
//         title: 'اختبار مكتمل',
//         message: 'أكمل الطالب أحمد محمود الاختبار: اختبار الوحدة الأولى',
//         type: 'success',
//         relatedEntityId: 's1',
//         relatedEntityType: 'student',
//         createdAt: DateTime.now().subtract(const Duration(days: 1)),
//         isRead: true,
//       ),
//     ];
//   }

//   /// الحصول على إحصائيات لوحة التحكم
//   static Map<String, dynamic> getDashboardStats() {
//     return {
//       'activeStudents': 32,
//       'classAverageScore': 78.5,
//       'quizCompletionRate': 0.85,
//       'suspiciousQuestions': 3,
//       'unreadNotifications': 2,
//       'totalClasses': 2,
//       'totalStudents': 67,
//     };
//   }
// }
