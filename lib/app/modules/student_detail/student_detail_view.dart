import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'student_detail_controller.dart';

class StudentDetailView extends GetView<StudentDetailController> {
  const StudentDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final student = controller.student.value;
      if (student == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('لم يتم العثور على الطالب')),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // App Bar with Student Header
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 50),
                        // Avatar
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
                              student.profileImage,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          student.name,
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${student.studentCode} • ${student.className}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        // const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Quick Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'المعدل',
                            value:
                                '${student.averageScore.toStringAsFixed(1)}%',
                            icon: Icons.star,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: 'الاختبارات',
                            value:
                                '${student.completedQuizzes}/${student.totalQuizzes}',
                            icon: Icons.quiz,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Mastery Level Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _getMasteryColor(
                          student.masteryLevel,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getMasteryColor(
                            student.masteryLevel,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getMasteryColor(
                                student.masteryLevel,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getMasteryIcon(student.masteryLevel),
                              color: _getMasteryColor(student.masteryLevel),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مستوى الإتقان',
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getMasteryLevelLabel(student.masteryLevel),
                                  style: AppTextStyles.h4.copyWith(
                                    color: _getMasteryColor(
                                      student.masteryLevel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.sendMessage,
                            icon: const Icon(Icons.message_outlined),
                            label: const Text('إرسال رسالة'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.callStudent,
                            icon: const Icon(Icons.phone_outlined),
                            label: const Text('اتصال'),
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
                    _buildTabContent(student),
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
    required String title,
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
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption),
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
              child: _buildTab(
                title: 'الأداء',
                icon: Icons.trending_up,
                index: 0,
              ),
            ),
            Expanded(
              child: _buildTab(title: 'السجل', icon: Icons.history, index: 1),
            ),
            Expanded(
              child: _buildTab(
                title: 'التحليلات',
                icon: Icons.analytics_outlined,
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

  Widget _buildTabContent(student) {
    return Obx(() {
      switch (controller.selectedTabIndex.value) {
        case 0:
          return _buildPerformanceTab(student);
        case 1:
          return _buildHistoryTab(student);
        case 2:
          return _buildAnalyticsTab(student);
        default:
          return const SizedBox();
      }
    });
  }

  Widget _buildPerformanceTab(student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('أداء المواضيع', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        ...student.subjectPerformance
            .map(
              (subject) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subject.subjectName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              _getTrendIcon(subject.trend),
                              color: _getTrendColor(subject.trend),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${subject.score.toStringAsFixed(1)}%',
                              style: AppTextStyles.labelBold.copyWith(
                                color: _getScoreColor(subject.score),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: subject.score / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getScoreColor(subject.score),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildHistoryTab(student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('آخر الاختبارات', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        ...List.generate(5, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.quiz_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختبار الجبر - الوحدة ${index + 1}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'منذ ${index + 1} يوم',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${85 - index * 3}%',
                  style: AppTextStyles.h4.copyWith(
                    color: _getScoreColor(85 - index * 3),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAnalyticsTab(student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تحليلات مفصلة', style: AppTextStyles.h4),
        const SizedBox(height: 16),

        // Strengths
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('نقاط القوة', style: AppTextStyles.h4),
                ],
              ),
              const SizedBox(height: 16),
              _buildAnalyticsItem('الجبر الخطي', 95.0),
              _buildAnalyticsItem('حل المعادلات', 92.0),
              _buildAnalyticsItem('التحليل إلى عوامل', 88.0),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Weaknesses
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.trending_down,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('يحتاج تحسين', style: AppTextStyles.h4),
                ],
              ),
              const SizedBox(height: 16),
              _buildAnalyticsItem('المتتاليات الهندسية', 65.0),
              _buildAnalyticsItem('المعادلات التربيعية', 68.0),
              _buildAnalyticsItem('حساب المثلثات', 72.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsItem(String title, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(score),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${score.toStringAsFixed(0)}%',
            style: AppTextStyles.labelBold.copyWith(
              color: _getScoreColor(score),
            ),
          ),
        ],
      ),
    );
  }

  String _getMasteryLevelLabel(String level) {
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

  IconData _getMasteryIcon(String level) {
    switch (level) {
      case 'Mastered':
        return Icons.emoji_events;
      case 'Proficient':
        return Icons.thumb_up;
      case 'Developing':
        return Icons.trending_up;
      case 'Needs Improvement':
        return Icons.priority_high;
      default:
        return Icons.help_outline;
    }
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

  Color _getScoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }
}
