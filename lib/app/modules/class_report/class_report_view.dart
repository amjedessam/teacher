import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teacher/app/data/models/student_model.dart';
import 'package:teacher/app/modules/class_report/class_report_controller.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ClassReportView extends GetView<ClassReportController> {
  const ClassReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('تقرير الفصل', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              Get.snackbar('تصدير', 'جاري تصدير التقرير...');
            },
            tooltip: 'تصدير PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: controller.selectedClassId.value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: controller.classes
                      .map(
                        (classItem) => DropdownMenuItem<String>(
                          value: classItem.id,
                          child: Row(
                            children: [
                              Text(
                                classItem.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(classItem.name),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: controller.changeClass,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewStats(),

                  const SizedBox(height: 24),

                  _buildDistributionChart(),

                  const SizedBox(height: 24),

                  _buildGradeDistribution(),

                  const SizedBox(height: 24),

                  _buildTopStudents(),

                  const SizedBox(height: 24),

                  if (controller.strugglingStudents.isNotEmpty)
                    _buildStrugglingStudents(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'معدل الفصل',
              '${controller.classAverage.toStringAsFixed(1)}%',
              Icons.star,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'عدد الطلاب',
              '${controller.students.length}',
              Icons.people,
              AppColors.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'الناجحون',
              '${controller.students.where((s) => s.avgScore >= 60).length}',
              Icons.check_circle,
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
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
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('توزيع الدرجات', style: AppTextStyles.h4),
          const SizedBox(height: 20),
          Obx(() {
            final total = controller.students.length;
            if (total == 0) return const SizedBox();

            return SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      value: controller.excellentCount.toDouble(),
                      title:
                          '${((controller.excellentCount / total) * 100).toInt()}%',
                      color: AppColors.success,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: controller.goodCount.toDouble(),
                      title:
                          '${((controller.goodCount / total) * 100).toInt()}%',
                      color: AppColors.info,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: controller.averageCount.toDouble(),
                      title:
                          '${((controller.averageCount / total) * 100).toInt()}%',
                      color: AppColors.warning,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: controller.weakCount.toDouble(),
                      title:
                          '${((controller.weakCount / total) * 100).toInt()}%',
                      color: AppColors.error,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Obx(
            () => Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildLegendItem(
                  'ممتاز (90%+)',
                  AppColors.success,
                  controller.excellentCount,
                ),
                _buildLegendItem(
                  'جيد (70-89%)',
                  AppColors.info,
                  controller.goodCount,
                ),
                _buildLegendItem(
                  'متوسط (50-69%)',
                  AppColors.warning,
                  controller.averageCount,
                ),
                _buildLegendItem(
                  'ضعيف (<50%)',
                  AppColors.error,
                  controller.weakCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text('$label ($count)', style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildGradeDistribution() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('التوزيع التفصيلي', style: AppTextStyles.h4),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.students.isEmpty) return const SizedBox();

            final ranges = {
              '90-100': controller.students
                  .where((s) => s.avgScore >= 90)
                  .length,
              '80-89': controller.students
                  .where((s) => s.avgScore >= 80 && s.avgScore < 90)
                  .length,
              '70-79': controller.students
                  .where((s) => s.avgScore >= 70 && s.avgScore < 80)
                  .length,
              '60-69': controller.students
                  .where((s) => s.avgScore >= 60 && s.avgScore < 70)
                  .length,
              '50-59': controller.students
                  .where((s) => s.avgScore >= 50 && s.avgScore < 60)
                  .length,
              '<50': controller.students.where((s) => s.avgScore < 50).length,
            };

            return SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.students.length.toDouble() + 2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: AppColors.primary,

                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} طالب',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final labels = ranges.keys.toList();
                          if (value.toInt() >= 0 &&
                              value.toInt() < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[value.toInt()],
                                style: AppTextStyles.caption,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: ranges.entries.map((entry) {
                    final index = ranges.keys.toList().indexOf(entry.key);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          gradient: AppColors.primaryGradient,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopStudents() {
    return Obx(() {
      final topStudents = controller.topStudents;
      if (topStudents.isEmpty) return const SizedBox();

      return Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.warning),
                const SizedBox(width: 8),
                Text('الطلاب المتفوقون', style: AppTextStyles.h4),
              ],
            ),
            const SizedBox(height: 16),
            ...topStudents.asMap().entries.map((entry) {
              final index = entry.key;
              final student = entry.value;
              return _buildStudentRow(
                student: student,
                rank: index,
                scoreColor: AppColors.success,
                bgColor: AppColors.success.withOpacity(0.05),
                borderColor: AppColors.success.withOpacity(0.2),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildStrugglingStudents() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, color: AppColors.error),
                const SizedBox(width: 8),
                Text('الطلاب المتعثرون', style: AppTextStyles.h4),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'يحتاجون دعم إضافي',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ...controller.strugglingStudents.map((student) {
              return _buildStudentRow(
                student: student,
                rank: -1,
                scoreColor: AppColors.error,
                bgColor: AppColors.error.withOpacity(0.05),
                borderColor: AppColors.error.withOpacity(0.2),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentRow({
    required ClassReportStudent student,
    required int rank,
    required Color scoreColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: () {
        final studentModel = StudentModel(
          id: student.studentId.toString(),
          name: student.studentName,
          email: '',
          studentCode: student.studentCode,
          classId: controller.selectedClassId.value ?? '',
          className: controller.selectedClass?.name ?? '',
          profileImage: student.profileImage ?? '',
          averageScore: student.avgScore,
          totalQuizzes: student.totalExams,
          completedQuizzes: student.totalExams,
          masteryLevel: student.avgScore >= 85
              ? 'Mastered'
              : student.avgScore >= 70
              ? 'Proficient'
              : student.avgScore >= 50
              ? 'Developing'
              : 'Needs Improvement',
          subjectPerformance: [],
          lastActive: DateTime.now(),
        );
        Get.toNamed(
          AppRoutes.studentDetail,
          arguments: {'student': studentModel},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            if (rank >= 0)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: _getRankGradient(rank),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${rank + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person_outline, color: scoreColor, size: 20),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (student.totalExams > 0)
                    Text(
                      '${student.totalExams} اختبار • ${student.passed} ناجح',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${student.avgScore.toStringAsFixed(1)}%',
              style: AppTextStyles.h4.copyWith(color: scoreColor),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: scoreColor),
          ],
        ),
      ),
    );
  }

  LinearGradient _getRankGradient(int rank) {
    switch (rank) {
      case 0:
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      case 1:
        return const LinearGradient(
          colors: [Color(0xFFC0C0C0), Color(0xFF999999)],
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
        );
      default:
        return AppColors.primaryGradient;
    }
  }
}
