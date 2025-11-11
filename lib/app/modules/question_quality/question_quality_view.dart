// // question_quality_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import 'question_quality_controller.dart';

// class QuestionQualityView extends GetView<QuestionQualityController> {
//   const QuestionQualityView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: Text('تحليل جودة الأسئلة', style: AppTextStyles.h3),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Summary Cards
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'ممتاز',
//                       controller.excellentQuestions.length.toString(),
//                       AppColors.success,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'جيد',
//                       controller.goodQuestions.length.toString(),
//                       AppColors.info,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'مقبول',
//                       controller.fairQuestions.length.toString(),
//                       AppColors.warning,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildSummaryCard(
//                       'ضعيف',
//                       controller.poorQuestions.length.toString(),
//                       AppColors.error,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),

//               Text('الأسئلة التي تحتاج مراجعة', style: AppTextStyles.h4),
//               const SizedBox(height: 16),

//               if (controller.poorQuestions.isEmpty &&
//                   controller.fairQuestions.isEmpty)
//                 _buildEmptyState()
//               else
//                 ...[
//                   ...controller.poorQuestions,
//                   ...controller.fairQuestions,
//                 ].map((q) => _buildQuestionCard(q)).toList(),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildSummaryCard(String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: AppTextStyles.displayMedium.copyWith(
//               color: color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(label, style: AppTextStyles.bodySmall),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionCard(question) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             question.questionText,
//             style: AppTextStyles.bodyMedium,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _buildBadge(
//                 'DI: ${(question.difficultyIndex * 100).toInt()}%',
//                 AppColors.info,
//               ),
//               const SizedBox(width: 8),
//               _buildBadge(
//                 'DiscI: ${(question.discriminationIndex * 100).toInt()}%',
//                 AppColors.warning,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBadge(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           children: [
//             const Text('✅', style: TextStyle(fontSize: 60)),
//             const SizedBox(height: 16),
//             Text(
//               'جميع الأسئلة بجودة ممتازة!',
//               style: AppTextStyles.h4,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// question_quality_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/modules/question_quality/question_quality_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class QuestionQualityView extends GetView<QuestionQualityController> {
  const QuestionQualityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('تحليل جودة الأسئلة', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'ممتاز',
                      controller.excellentQuestions.length.toString(),
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'جيد',
                      controller.goodQuestions.length.toString(),
                      AppColors.info,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'مقبول',
                      controller.fairQuestions.length.toString(),
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'ضعيف',
                      controller.poorQuestions.length.toString(),
                      AppColors.error,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text('الأسئلة التي تحتاج مراجعة', style: AppTextStyles.h4),
              const SizedBox(height: 16),

              if (controller.poorQuestions.isEmpty &&
                  controller.fairQuestions.isEmpty)
                _buildEmptyState()
              else
                ...[
                  ...controller.poorQuestions,
                  ...controller.fairQuestions,
                ].map((q) => _buildQuestionCard(q)).toList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.questionText,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadge(
                'DI: ${(question.difficultyIndex * 100).toInt()}%',
                AppColors.info,
              ),
              const SizedBox(width: 8),
              _buildBadge(
                'DiscI: ${(question.discriminationIndex * 100).toInt()}%',
                AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('✅', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              'جميع الأسئلة بجودة ممتازة!',
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
