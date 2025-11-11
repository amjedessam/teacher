import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/class_model.dart';
import 'classes_controller.dart';

class ClassesView extends GetView<ClassesController> {
  const ClassesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'فصولي الدراسية',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshClasses,
          child: Column(
            children: [
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: controller.searchClasses,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن فصل...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              // Classes List
              Expanded(
                child: controller.filteredClasses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.filteredClasses.length,
                        itemBuilder: (context, index) {
                          final classItem = controller.filteredClasses[index];
                          return _buildClassCard(classItem);
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildClassCard(ClassModel classItem) {
    final color = Color(int.parse(classItem.color));

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
        onTap: () => controller.viewClassDetails(classItem),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        classItem.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Class Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classItem.name,
                          style: AppTextStyles.h4.copyWith(color: color),
                        ),
                        const SizedBox(height: 4),
                        Text(classItem.grade, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),

                  // Average Score Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(
                        classItem.averageScore,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${classItem.averageScore.toStringAsFixed(1)}%',
                      style: AppTextStyles.labelBold.copyWith(
                        color: _getScoreColor(classItem.averageScore),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.people_outline,
                      label: 'الطلاب',
                      value:
                          '${classItem.activeStudents}/${classItem.totalStudents}',
                      color: color,
                    ),
                  ),
                  Container(width: 1, height: 30, color: AppColors.border),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.quiz_outlined,
                      label: 'الاختبارات',
                      value: '${classItem.totalQuizzes}',
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value, style: AppTextStyles.labelBold.copyWith(color: color)),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📚', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('لا توجد فصول', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على فصول دراسية',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
