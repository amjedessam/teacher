// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:teacher/app/modules/question_quality/question_quality_controller.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';

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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'question_quality_controller.dart';

class QuestionQualityView extends GetView<QuestionQualityController> {
  const QuestionQualityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل جودة الأسئلة'),
        centerTitle: true,
      ),
      body: controller.obx(
        (state) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. إحصائيات جودة بنك الأسئلة
              _buildQualityStatsCard(),
              const SizedBox(height: 24),

              // 2. قائمة الأسئلة التي تحتاج مراجعة
              Text(
                'الأسئلة التي تحتاج مراجعة (${controller.suspiciousQuestions.length})',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // عرض قائمة الأسئلة المشبوهة
              ...controller.suspiciousQuestions.map((question) {
                return _buildQuestionItem(question);
              }).toList(),
            ],
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text('خطأ: $error')),
        onEmpty: const Center(
          child: Text(
            'لا توجد أسئلة تحتاج مراجعة حالياً. بنك الأسئلة في حالة ممتازة!',
          ),
        ),
      ),
    );
  }

  Widget _buildQualityStatsCard() {
    return Obx(() {
      if (controller.qualityStats.isEmpty) {
        return const SizedBox.shrink();
      }
      final stats = controller.qualityStats;
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إحصائيات بنك الأسئلة',
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 20),
              _buildStatRow('إجمالي الأسئلة', stats['total'].toString()),
              _buildStatRow(
                'أسئلة ممتازة',
                '${stats['excellent']} (${stats['excellentPercentage'].toStringAsFixed(1)}%)',
                color: controller.getQualityColor('ممتاز'),
              ),
              _buildStatRow(
                'أسئلة جيدة',
                stats['good'].toString(),
                color: controller.getQualityColor('جيد'),
              ),
              _buildStatRow(
                'أسئلة تحتاج مراجعة',
                '${stats['needsReview']} (${stats['needsReviewPercentage'].toStringAsFixed(1)}%)',
                color: controller.getQualityColor('يحتاج مراجعة'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Get.textTheme.bodyLarge),
          Text(
            value,
            style: Get.textTheme.titleMedium?.copyWith(
              color: color ?? Get.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(question) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: controller.getQualityColor(question.quality),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              'التصنيف:',
              question.quality,
              controller.getQualityColor(question.quality),
            ),
            _buildDetailRow(
              'مؤشر الصعوبة (DI):',
              question.difficultyIndex.toStringAsFixed(2),
              question.difficultyIndex < 0.3 || question.difficultyIndex > 0.9
                  ? Colors.red
                  : Colors.green,
            ),
            _buildDetailRow(
              'مؤشر التمييز (DiscI):',
              question.discriminationIndex.toStringAsFixed(2),
              controller.getDiscriminationColor(question.discriminationIndex),
            ),
            _buildDetailRow('مرات الاستخدام:', question.timesUsed.toString()),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  // هنا يتم توجيه المستخدم إلى شاشة تعديل السؤال
                  Get.snackbar(
                    'تعديل السؤال',
                    'سيتم التوجيه إلى شاشة تعديل السؤال ${question.id}',
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('مراجعة وتعديل'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(value, style: Get.textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
