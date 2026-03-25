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
            // ✅ الخلاصة اليومية + النشاط
            _buildReportCard(
              title: 'الخلاصة اليومية والأنشطة',
              description: 'إنشاء خلاصة الحصة وواجبات الفصل',
              icon: Icons.today_outlined,
              color: AppColors.error,
              onTap: controller.openDailyReport,
            ),

            _buildReportCard(
              title: 'الفجوات المنهجية',
              description: 'المواضيع التي تحتاج تركيز أكثر',
              icon: Icons.warning_amber,
              color: AppColors.warning,
              onTap: controller.openCurriculumGaps,
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
    bool isDisabled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDisabled ? AppColors.background : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDisabled ? Border.all(color: AppColors.border) : null,
        boxShadow: isDisabled
            ? null
            : [
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
                  color: color.withOpacity(isDisabled ? 0.05 : 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isDisabled ? AppColors.textLight : color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h4.copyWith(
                        color: isDisabled ? AppColors.textSecondary : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDisabled ? AppColors.textLight : null,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isDisabled ? Icons.lock_outline : Icons.arrow_forward_ios,
                size: 18,
                color: isDisabled ? AppColors.textLight : AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
