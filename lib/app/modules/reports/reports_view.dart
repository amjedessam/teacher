// // reports_view.dart - simplified
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import 'reports_controller.dart';

// class ReportsView extends GetView<ReportsController> {
//   const ReportsView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: Text('التقارير', style: AppTextStyles.h3),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('تقارير شاملة', style: AppTextStyles.h2),
//             const SizedBox(height: 8),
//             Text(
//               'تحليلات مفصلة عن أداء الطلاب والفصول',
//               style: AppTextStyles.bodyMedium.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 24),

//             _buildReportCard(
//               title: 'تقرير الفصل',
//               description: 'أداء الفصل الدراسي الكامل',
//               icon: Icons.class_,
//               color: AppColors.primary,
//               onTap: () {},
//             ),
//             _buildReportCard(
//               title: 'تقرير المادة',
//               description: 'تحليل أداء المواضيع المختلفة',
//               icon: Icons.subject,
//               color: AppColors.secondary,
//               onTap: () {},
//             ),
//             _buildReportCard(
//               title: 'الفجوات المنهجية',
//               description: 'المواضيع التي تحتاج تركيز أكثر',
//               icon: Icons.warning_amber,
//               color: AppColors.warning,
//               onTap: () {},
//             ),
//             _buildReportCard(
//               title: 'تقرير الطلاب المتعثرين',
//               description: 'الطلاب الذين يحتاجون دعم إضافي',
//               icon: Icons.people_outline,
//               color: AppColors.error,
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReportCard({
//     required String title,
//     required String description,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowLight,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Icon(icon, color: color, size: 28),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title, style: AppTextStyles.h4),
//                     const SizedBox(height: 4),
//                     Text(description, style: AppTextStyles.bodySmall),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 18,
//                 color: AppColors.textLight,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// reports_view.dart - simplified
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/modules/reports/reports_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('التقارير', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تقارير شاملة', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'تحليلات مفصلة عن أداء الطلاب والفصول',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            _buildReportCard(
              title: 'تقرير الفصل',
              description: 'أداء الفصل الدراسي الكامل',
              icon: Icons.class_,
              color: AppColors.primary,
              onTap: controller.openClassReport,
            ),
            _buildReportCard(
              title: 'تقرير المادة',
              description: 'تحليل أداء المواضيع المختلفة',
              icon: Icons.subject,
              color: AppColors.secondary,
              onTap: controller.openSubjectReport,
            ),
            _buildReportCard(
              title: 'الفجوات المنهجية',
              description: 'المواضيع التي تحتاج تركيز أكثر',
              icon: Icons.warning_amber,
              color: AppColors.warning,
              onTap: controller.openCurriculumGaps,
            ),
            _buildReportCard(
              title: 'تقرير الطلاب المتعثرين',
              description: 'الطلاب الذين يحتاجون دعم إضافي',
              icon: Icons.people_outline,
              color: AppColors.error,
              onTap: controller.openStrugglingStudents,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h4),
                    const SizedBox(height: 4),
                    Text(description, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
