// class QuestionQualityModel {
//   final String questionId;
//   final String questionText;
//   final String type;
//   final String unit;
//   final String skill;
//   final String difficulty;
//   final int usageCount;
//   final double correctRate;
//   final double difficultyIndex;
//   final double discriminationIndex;
//   final String qualityLabel;
//   final bool isSuspicious;
//   final DateTime lastUpdated;

//   QuestionQualityModel({
//     required this.questionId,
//     required this.questionText,
//     required this.type,
//     required this.unit,
//     required this.skill,
//     required this.difficulty,
//     required this.usageCount,
//     required this.correctRate,
//     required this.difficultyIndex,
//     required this.discriminationIndex,
//     required this.qualityLabel,
//     required this.isSuspicious,
//     required this.lastUpdated,
//   });

//   factory QuestionQualityModel.fromJson(Map<String, dynamic> json) {
//     return QuestionQualityModel(
//       questionId: json['question_id'],
//       questionText: json['question_text'],
//       type: json['type'],
//       unit: json['unit'],
//       skill: json['skill'],
//       difficulty: json['difficulty'],
//       usageCount: json['usage_count'],
//       correctRate: (json['correct_rate'] as num).toDouble(),
//       difficultyIndex: (json['difficulty_index'] as num).toDouble(),
//       discriminationIndex: (json['discrimination_index'] as num).toDouble(),
//       qualityLabel: json['quality_label'],
//       isSuspicious: json['is_suspicious'] ?? false,
//       lastUpdated: DateTime.parse(json['last_updated']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'question_id': questionId,
//       'question_text': questionText,
//       'type': type,
//       'unit': unit,
//       'skill': skill,
//       'difficulty': difficulty,
//       'usage_count': usageCount,
//       'correct_rate': correctRate,
//       'difficulty_index': difficultyIndex,
//       'discrimination_index': discriminationIndex,
//       'quality_label': qualityLabel,
//       'is_suspicious': isSuspicious,
//       'last_updated': lastUpdated.toIso8601String(),
//     };
//   }

//   /// حساب تصنيف الجودة بناءً على المؤشرات
//   static String calculateQualityLabel(
//     double difficultyIndex,
//     double discriminationIndex,
//   ) {
//     if (difficultyIndex < 0.3 || difficultyIndex > 0.9) {
//       return 'يحتاج مراجعة';
//     } else if (discriminationIndex < 0.2) {
//       return 'يحتاج مراجعة';
//     } else if (discriminationIndex >= 0.4) {
//       return 'ممتاز';
//     } else {
//       return 'جيد';
//     }
//   }

//   /// التحقق من كون السؤال مشبوهًا
//   static bool isSuspiciousQuestion(double correctRate) {
//     return correctRate < 0.3 || correctRate > 0.9;
//   }
// }
