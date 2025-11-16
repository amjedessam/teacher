import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/services/curriculum_gap_analysis_service.dart';
import 'curriculum_gaps_controller.dart';

class CurriculumGapsView extends GetView<CurriculumGapsController> {
  const CurriculumGapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('الفجوات المنهجية', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reanalyze,
            tooltip: 'إعادة التحليل',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final gaps = controller.gaps;

        if (gaps.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 24),
              Text('الفجوات المكتشفة', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              ...gaps.map((gap) => _buildGapCard(gap)).toList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(() {
      final stats = controller.gapStats;
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'إجمالي',
              stats['totalGaps'].toString(),
              AppColors.primary,
              Icons.assessment,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'حرجة',
              stats['criticalGaps'].toString(),
              AppColors.error,
              Icons.warning_amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'عالية',
              stats['highGaps'].toString(),
              AppColors.warning,
              Icons.priority_high,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildGapCard(CurriculumGap gap) {
    final severityColor = _getSeverityColor(gap.severity);
    final severityLabel = _getSeverityLabel(gap.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),

              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getSeverityIcon(gap.severity),
                  color: severityColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gap.chapter, style: AppTextStyles.h4),
                      const SizedBox(height: 4),
                      Text(gap.unit, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    severityLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric(
                        'معدل الفشل',
                        '${(gap.failureRate * 100).toStringAsFixed(0)}%',
                        severityColor,
                      ),
                    ),
                    Expanded(
                      child: _buildMetric(
                        'الطلاب المتأثرون',
                        '${gap.failedStudents}/${gap.totalStudents}',
                        severityColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('التوصيات:', style: AppTextStyles.labelBold),
                ),
                const SizedBox(height: 8),
                Text(gap.recommendation, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h4.copyWith(color: color)),
      ],
    );
  }

  Color _getSeverityColor(GapSeverity severity) {
    switch (severity) {
      case GapSeverity.critical:
        return AppColors.error;
      case GapSeverity.high:
        return AppColors.warning;
      case GapSeverity.medium:
        return Colors.orange;
      case GapSeverity.low:
        return AppColors.info;
    }
  }

  String _getSeverityLabel(GapSeverity severity) {
    switch (severity) {
      case GapSeverity.critical:
        return 'حرجة';
      case GapSeverity.high:
        return 'عالية';
      case GapSeverity.medium:
        return 'متوسطة';
      case GapSeverity.low:
        return 'منخفضة';
    }
  }

  IconData _getSeverityIcon(GapSeverity severity) {
    switch (severity) {
      case GapSeverity.critical:
        return Icons.error;
      case GapSeverity.high:
        return Icons.warning_amber;
      case GapSeverity.medium:
        return Icons.info_outline;
      case GapSeverity.low:
        return Icons.check_circle_outline;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✅', style: TextStyle(fontSize: 80)),

          const SizedBox(height: 16),
          Text('لا توجد فجوات منهجية', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'جميع الطلاب يحققون أداءً جيداً في جميع الوحدات',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
