// class StudentReportModel {
//   final String studentId;
//   final String studentName;
//   final Map<String, double> masteryPerSkill;
//   final List<SkillStrengthWeakness> strengthsAndWeaknesses;
//   final List<QuizAttempt> quizAttempts;
//   final List<String> recommendations;
//   final double overallProgress;
//   final DateTime generatedAt;

//   StudentReportModel({
//     required this.studentId,
//     required this.studentName,
//     required this.masteryPerSkill,
//     required this.strengthsAndWeaknesses,
//     required this.quizAttempts,
//     required this.recommendations,
//     required this.overallProgress,
//     required this.generatedAt,
//   });

//   factory StudentReportModel.fromJson(Map<String, dynamic> json) {
//     return StudentReportModel(
//       studentId: json['student_id'],
//       studentName: json['student_name'],
//       masteryPerSkill: Map<String, double>.from(
//         (json['mastery_per_skill'] as Map).map(
//           (k, v) => MapEntry(k, (v as num).toDouble()),
//         ),
//       ),
//       strengthsAndWeaknesses: (json['strengths_and_weaknesses'] as List?)
//           ?.map((e) => SkillStrengthWeakness.fromJson(e))
//           .toList() ?? [],
//       quizAttempts: (json['quiz_attempts'] as List?)
//           ?.map((e) => QuizAttempt.fromJson(e))
//           .toList() ?? [],
//       recommendations: List<String>.from(json['recommendations'] ?? []),
//       overallProgress: (json['overall_progress'] as num).toDouble(),
//       generatedAt: DateTime.parse(json['generated_at']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'student_id': studentId,
//       'student_name': studentName,
//       'mastery_per_skill': masteryPerSkill,
//       'strengths_and_weaknesses': strengthsAndWeaknesses.map((e) => e.toJson()).toList(),
//       'quiz_attempts': quizAttempts.map((e) => e.toJson()).toList(),
//       'recommendations': recommendations,
//       'overall_progress': overallProgress,
//       'generated_at': generatedAt.toIso8601String(),
//     };
//   }
// }

// class ClassReportModel {
//   final String classId;
//   final String className;
//   final int totalStudents;
//   final double classAverageScore;
//   final Map<String, double> averageScorePerUnit;
//   final List<StudentPerformance> studentPerformances;
//   final List<String> strugglingStudents;
//   final double completionRate;
//   final DateTime generatedAt;

//   ClassReportModel({
//     required this.classId,
//     required this.className,
//     required this.totalStudents,
//     required this.classAverageScore,
//     required this.averageScorePerUnit,
//     required this.studentPerformances,
//     required this.strugglingStudents,
//     required this.completionRate,
//     required this.generatedAt,
//   });

//   factory ClassReportModel.fromJson(Map<String, dynamic> json) {
//     return ClassReportModel(
//       classId: json['class_id'],
//       className: json['class_name'],
//       totalStudents: json['total_students'],
//       classAverageScore: (json['class_average_score'] as num).toDouble(),
//       averageScorePerUnit: Map<String, double>.from(
//         (json['average_score_per_unit'] as Map).map(
//           (k, v) => MapEntry(k, (v as num).toDouble()),
//         ),
//       ),
//       studentPerformances: (json['student_performances'] as List?)
//           ?.map((e) => StudentPerformance.fromJson(e))
//           .toList() ?? [],
//       strugglingStudents: List<String>.from(json['struggling_students'] ?? []),
//       completionRate: (json['completion_rate'] as num).toDouble(),
//       generatedAt: DateTime.parse(json['generated_at']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'class_id': classId,
//       'class_name': className,
//       'total_students': totalStudents,
//       'class_average_score': classAverageScore,
//       'average_score_per_unit': averageScorePerUnit,
//       'student_performances': studentPerformances.map((e) => e.toJson()).toList(),
//       'struggling_students': strugglingStudents,
//       'completion_rate': completionRate,
//       'generated_at': generatedAt.toIso8601String(),
//     };
//   }
// }

// class SkillStrengthWeakness {
//   final String skill;
//   final double masteryLevel;
//   final bool isStrength;

//   SkillStrengthWeakness({
//     required this.skill,
//     required this.masteryLevel,
//     required this.isStrength,
//   });

//   factory SkillStrengthWeakness.fromJson(Map<String, dynamic> json) {
//     return SkillStrengthWeakness(
//       skill: json['skill'],
//       masteryLevel: (json['mastery_level'] as num).toDouble(),
//       isStrength: json['is_strength'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'skill': skill,
//       'mastery_level': masteryLevel,
//       'is_strength': isStrength,
//     };
//   }
// }

// class QuizAttempt {
//   final String quizId;
//   final String quizName;
//   final int score;
//   final int totalQuestions;
//   final double percentage;
//   final DateTime attemptDate;

//   QuizAttempt({
//     required this.quizId,
//     required this.quizName,
//     required this.score,
//     required this.totalQuestions,
//     required this.percentage,
//     required this.attemptDate,
//   });

//   factory QuizAttempt.fromJson(Map<String, dynamic> json) {
//     return QuizAttempt(
//       quizId: json['quiz_id'],
//       quizName: json['quiz_name'],
//       score: json['score'],
//       totalQuestions: json['total_questions'],
//       percentage: (json['percentage'] as num).toDouble(),
//       attemptDate: DateTime.parse(json['attempt_date']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'quiz_id': quizId,
//       'quiz_name': quizName,
//       'score': score,
//       'total_questions': totalQuestions,
//       'percentage': percentage,
//       'attempt_date': attemptDate.toIso8601String(),
//     };
//   }
// }

// class StudentPerformance {
//   final String studentId;
//   final String studentName;
//   final double averageScore;
//   final int quizzesCompleted;
//   final double masteryLevel;

//   StudentPerformance({
//     required this.studentId,
//     required this.studentName,
//     required this.averageScore,
//     required this.quizzesCompleted,
//     required this.masteryLevel,
//   });

//   factory StudentPerformance.fromJson(Map<String, dynamic> json) {
//     return StudentPerformance(
//       studentId: json['student_id'],
//       studentName: json['student_name'],
//       averageScore: (json['average_score'] as num).toDouble(),
//       quizzesCompleted: json['quizzes_completed'],
//       masteryLevel: (json['mastery_level'] as num).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'student_id': studentId,
//       'student_name': studentName,
//       'average_score': averageScore,
//       'quizzes_completed': quizzesCompleted,
//       'mastery_level': masteryLevel,
//     };
//   }
// }
