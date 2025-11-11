import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'class_detail_controller.dart';

class ClassDetailView extends GetView<ClassDetailController> {
  const ClassDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final classItem = controller.classItem.value;
      if (classItem == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('لم يتم العثور على الفصل')),
        );
      }

      final color = Color(int.parse(classItem.color));

      return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // App Bar Header
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              classItem.icon,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          classItem.name,
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classItem.grade,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'الطلاب',
                            value:
                                '${classItem.activeStudents}/${classItem.totalStudents}',
                            icon: Icons.people,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 'الاختبارات',
                            value: '${classItem.totalQuizzes}',
                            icon: Icons.quiz,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 'المعدل',
                            value:
                                '${classItem.averageScore.toStringAsFixed(1)}%',
                            icon: Icons.star,
                            color: color,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.sendMessageToClass,
                            icon: const Icon(Icons.message_outlined),
                            label: const Text('رسالة جماعية'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.createQuizForClass,
                            icon: const Icon(Icons.add),
                            label: const Text('إنشاء اختبار'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tabs
                    _buildTabs(),

                    const SizedBox(height: 16),

                    // Tab Content
                    _buildTabContent(classItem, color),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
          Text(
            value,
            style: AppTextStyles.h4.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
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

  Widget _buildTabs() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTab(title: 'الطلاب', icon: Icons.people, index: 0),
            ),
            Expanded(
              child: _buildTab(
                title: 'الإحصائيات',
                icon: Icons.analytics,
                index: 1,
              ),
            ),
            Expanded(
              child: _buildTab(
                title: 'الأداء',
                icon: Icons.trending_up,
                index: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final isSelected = controller.selectedTabIndex.value == index;

    return InkWell(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(classItem, Color color) {
    return Obx(() {
      switch (controller.selectedTabIndex.value) {
        case 0:
          return _buildStudentsTab();
        case 1:
          return _buildStatisticsTab(classItem, color);
        case 2:
          return _buildPerformanceTab(classItem, color);
        default:
          return const SizedBox();
      }
    });
  }

  Widget _buildStudentsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.students.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قائمة الطلاب (${controller.students.length})',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),
          ...controller.students
              .map(
                (student) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: InkWell(
                    onTap: () => controller.viewStudentDetail(student),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                student.profileImage,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student.studentCode,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${student.averageScore.toStringAsFixed(1)}%',
                                style: AppTextStyles.h4.copyWith(
                                  color: _getScoreColor(student.averageScore),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getMasteryColor(
                                    student.masteryLevel,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getMasteryLabel(student.masteryLevel),
                                  style: AppTextStyles.caption.copyWith(
                                    color: _getMasteryColor(
                                      student.masteryLevel,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      );
    });
  }

  Widget _buildStatisticsTab(classItem, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إحصائيات الفصل', style: AppTextStyles.h4),
        const SizedBox(height: 16),

        // Performance Distribution
        Container(
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
              Text('توزيع مستويات الإتقان', style: AppTextStyles.labelBold),
              const SizedBox(height: 20),
              _buildDistributionBar('متقن', 30, AppColors.success),
              _buildDistributionBar('جيد', 40, AppColors.info),
              _buildDistributionBar('متوسط', 20, AppColors.warning),
              _buildDistributionBar('يحتاج تحسين', 10, AppColors.error),
            ],
          ),
        ),

        const SizedBox(height: 16), // Quiz Statistics
        Container(
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
            children: [
              _buildStatRow('إجمالي الاختبارات', '${classItem.totalQuizzes}'),
              const Divider(height: 24),
              _buildStatRow(
                'الاختبارات المكتملة',
                '${(classItem.totalQuizzes * 0.9).round()}',
              ),
              const Divider(height: 24),
              _buildStatRow('معدل الإكمال', '90%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionBar(String label, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text(
                '$percentage%',
                style: AppTextStyles.labelBold.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildPerformanceTab(classItem, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أداء المواضيع', style: AppTextStyles.h4),
        const SizedBox(height: 16),

        _buildPerformanceCard('الجبر', 85.5, 'up', AppColors.success),
        _buildPerformanceCard('الهندسة', 78.3, 'down', AppColors.warning),
        _buildPerformanceCard('حساب المثلثات', 82.1, 'up', AppColors.info),
        _buildPerformanceCard('الإحصاء', 76.8, 'stable', AppColors.warning),
      ],
    );
  }

  Widget _buildPerformanceCard(
    String subject,
    double score,
    String trend,
    Color color,
  ) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    _getTrendIcon(trend),
                    color: _getTrendColor(trend),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${score.toStringAsFixed(1)}%',
                    style: AppTextStyles.labelBold.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return AppColors.success;
      case 'down':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getMasteryLabel(String level) {
    switch (level) {
      case 'Mastered':
        return 'متقن';
      case 'Proficient':
        return 'جيد';
      case 'Developing':
        return 'متوسط';
      case 'Needs Improvement':
        return 'يحتاج تحسين';
      default:
        return level;
    }
  }

  Color _getMasteryColor(String level) {
    switch (level) {
      case 'Mastered':
        return AppColors.success;
      case 'Proficient':
        return AppColors.info;
      case 'Developing':
        return AppColors.warning;
      case 'Needs Improvement':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('👥', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('لا يوجد طلاب', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'لم يتم إضافة طلاب لهذا الفصل بعد',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
