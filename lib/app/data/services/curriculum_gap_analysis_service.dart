// import 'package:get/get.dart';
// import 'package:teacher/app/data/services/assessment_analysis_service.dart';
// import '../models/question_model.dart';
// import '../models/student_model.dart';
// import '../models/quiz_result_model.dart';
// import 'ai_service.dart';

// /// نموذج فجوة تعليمية
// class LearningGap {
//   final String topic;
//   final String severity; // عالية، متوسطة، منخفضة
//   final String description;
//   final List<String> recommendations;
//   final DateTime identifiedAt;

//   LearningGap({
//     required this.topic,
//     required this.severity,
//     required this.description,
//     required this.recommendations,
//     required this.identifiedAt,
//   });
// }

// /// خدمة تحليل الفجوات التعليمية
// class CurriculumGapAnalysisService extends GetxService {
//   final AiService _aiService = Get.find();
//   final AssessmentAnalysisService _assessmentService = Get.find();

//   /// تحديد الفجوات التعليمية في المنهج
//   Future<List<LearningGap>> identifyGaps({
//     required String subject,
//     required String curriculum,
//     required List<Map<String, dynamic>> unitPerformance,
//   }) async {
//     final gapsData = await _aiService.identifyLearningGaps(
//       classPerformance: unitPerformance,
//       subject: subject,
//       curriculum: curriculum,
//     );

//     final gaps = <LearningGap>[];
//     final gapsList = gapsData['gaps'] as List;

//     for (final gap in gapsList) {
//       gaps.add(LearningGap(
//         topic: gap['topic'] as String,
//         severity: gap['severity'] as String,
//         description: gap['description'] as String,
//         recommendations: List<String>.from(gap['recommendations']),
//         identifiedAt: DateTime.now(),
//       ));
//     }

//     return gaps;
//   }

//   /// تحليل الفجوات بناءً على أداء الطلاب
//   Future<List<LearningGap>> analyzePerformanceGaps({
//     required List<StudentModel> students,
//     required List<QuizResult> quizResults,
//     required String subject,
//   }) async {
//     // تجميع أداء الطلاب حسب الوحدات/المواضيع
//     final topicPerformance = <String, List<double>>{};

//     for (final result in quizResults) {
//       // افتراض أن quizTitle يحتوي على اسم الوحدة
//       final topic = _extractTopicFromQuizTitle(result.quizTitle);
//       topicPerformance.putIfAbsent(topic, () => []);
//       topicPerformance[topic]!.add(result.score);
//     }

//     // حساب متوسط الأداء لكل موضوع
//     final unitPerformance = topicPerformance.entries.map((entry) {
//       final scores = entry.value;
//       final average = scores.reduce((a, b) => a + b) / scores.length;
//       final passRate = scores.where((score) => score >= 60).length / scores.length * 100;

//       return {
//         'unit': entry.key,
//         'averageScore': average,
//         'passRate': passRate,
//       };
//     }).toList();

//     // تحديد المنهج العام (يمكن تخصيصه)
//     final curriculum = 'المنهج الدراسي لمادة $subject';

//     return await identifyGaps(
//       subject: subject,
//       curriculum: curriculum,
//       unitPerformance: unitPerformance,
//     );
//   }

//   /// توليد خطة تحسين لسد الفجوات
//   Future<String> generateImprovementPlan({
//     required List<LearningGap> gaps,
//     required String subject,
//   }) async {
//     final gapsText = gaps.map((gap) =>
//       'الموضوع: ${gap.topic}\nالخطورة: ${gap.severity}\nالوصف: ${gap.description}\nالتوصيات: ${gap.recommendations.join(", ")}'
//     ).join('\n\n');

//     final prompt = '''
// بناءً على الفجوات التعليمية التالية في مادة $subject:

// $gapsText

// أنشئ خطة تحسين شاملة باللغة العربية تحتوي على:
// 1. الأولويات لسد الفجوات
// 2. الإجراءات المقترحة لكل فجوة
// 3. الجدول الزمني المقترح
// 4. الموارد المطلوبة
// 5. طرق قياس التحسن
// ''';

//     return await _aiService.generateContent(prompt);
//   }

//   /// مراقبة تحسن الفجوات
//   Future<Map<String, dynamic>> monitorGapProgress({
//     required List<LearningGap> originalGaps,
//     required List<Map<String, dynamic>> currentPerformance,
//     required String subject,
//   }) async {
//     final progressData = await _aiService.identifyLearningGaps(
//       classPerformance: currentPerformance,
//       subject: subject,
//       curriculum: 'متابعة التحسن',
//     );

//     // مقارنة مع الفجوات الأصلية
//     final improvements = <String, dynamic>{};
//     final remainingGaps = <LearningGap>[];

//     for (final originalGap in originalGaps) {
//       final currentGap = (progressData['gaps'] as List).firstWhere(
//         (gap) => gap['topic'] == originalGap.topic,
//         orElse: () => null,
//       );

//       if (currentGap == null) {
//         // الفجوة تم سدها
//         improvements[originalGap.topic] = {
//           'status': 'improved',
//           'originalSeverity': originalGap.severity,
//           'currentSeverity': 'none',
//         };
//       } else {
//         final currentSeverity = currentGap['severity'] as String;
//         if (_getSeverityLevel(currentSeverity) < _getSeverityLevel(originalGap.severity)) {
//           improvements[originalGap.topic] = {
//             'status': 'improving',
//             'originalSeverity': originalGap.severity,
//             'currentSeverity': currentSeverity,
//           };
//         } else {
//           remainingGaps.add(originalGap);
//         }
//       }
//     }

//     return {
//       'improvements': improvements,
//       'remainingGaps': remainingGaps,
//       'overallAssessment': progressData['overallAssessment'],
//       'newRecommendations': progressData['priorityActions'],
//     };
//   }

//   String _extractTopicFromQuizTitle(String quizTitle) {
//     // منطق بسيط لاستخراج الموضوع من عنوان الاختبار
//     // يمكن تحسينه حسب تنسيق الأسماء
//     final parts = quizTitle.split(' - ');
//     return parts.isNotEmpty ? parts.first : quizTitle;
//   }

//   int _getSeverityLevel(String severity) {
//     switch (severity.toLowerCase()) {
//       case 'عالية': return 3;
//       case 'متوسطة': return 2;
//       case 'منخفضة': return 1;
//       default: return 0;
//     }
//   }
// }