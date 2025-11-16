import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/student_model.dart';
import 'students_controller.dart';

class StudentsView extends GetView<StudentsController> {
  const StudentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'الطلاب',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshStudents,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: controller.searchStudents,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن طالب...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              if (controller.selectedClassId.value != null ||
                  controller.selectedMasteryLevel.value != null)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (controller.selectedClassId.value != null)
                                _buildFilterChip(
                                  label: controller.classes
                                      .firstWhere(
                                        (c) =>
                                            c.id ==
                                            controller.selectedClassId.value,
                                      )
                                      .name,
                                  onDeleted: () =>
                                      controller.filterByClass(null),
                                ),
                              if (controller.selectedMasteryLevel.value != null)
                                _buildFilterChip(
                                  label: _getMasteryLevelLabel(
                                    controller.selectedMasteryLevel.value!,
                                  ),
                                  onDeleted: () =>
                                      controller.filterByMasteryLevel(null),
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: controller.clearFilters,
                        child: Text('مسح الكل'),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: controller.filteredStudents.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = controller.filteredStudents[index];
                          return _buildStudentCard(student);
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        onTap: () => controller.viewStudentDetail(student),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    student.profileImage,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: AppTextStyles.h4),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          student.studentCode,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Text('•', style: AppTextStyles.bodySmall),
                        const SizedBox(width: 8),
                        Text(student.className, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                            _getMasteryLevelLabel(student.masteryLevel),
                            style: AppTextStyles.caption.copyWith(
                              color: _getMasteryColor(student.masteryLevel),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${student.averageScore.toStringAsFixed(1)}%',
                    style: AppTextStyles.h3.copyWith(
                      color: _getScoreColor(student.averageScore),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('المعدل', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDeleted,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        deleteIconColor: AppColors.primary,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
      ),
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تصفية الطلاب', style: AppTextStyles.h3),
            const SizedBox(height: 10),

            // Filter by Class
            Text('الفصل الدراسي', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterOption(
                    label: 'الكل',
                    isSelected: controller.selectedClassId.value == null,
                    onTap: () => controller.filterByClass(null),
                  ),
                  ...controller.classes.map(
                    (classItem) => _buildFilterOption(
                      label: classItem.name,
                      isSelected:
                          controller.selectedClassId.value == classItem.id,
                      onTap: () => controller.filterByClass(classItem.id),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text('مستوى الإتقان', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterOption(
                    label: 'الكل',
                    isSelected: controller.selectedMasteryLevel.value == null,
                    onTap: () => controller.filterByMasteryLevel(null),
                  ),
                  _buildFilterOption(
                    label: 'متقن',
                    isSelected:
                        controller.selectedMasteryLevel.value == 'Mastered',
                    onTap: () => controller.filterByMasteryLevel('Mastered'),
                  ),
                  _buildFilterOption(
                    label: 'جيد',
                    isSelected:
                        controller.selectedMasteryLevel.value == 'Proficient',
                    onTap: () => controller.filterByMasteryLevel('Proficient'),
                  ),
                  _buildFilterOption(
                    label: 'متوسط',
                    isSelected:
                        controller.selectedMasteryLevel.value == 'Developing',
                    onTap: () => controller.filterByMasteryLevel('Developing'),
                  ),
                  _buildFilterOption(
                    label: 'يحتاج تحسين',
                    isSelected:
                        controller.selectedMasteryLevel.value ==
                        'Needs Improvement',
                    onTap: () =>
                        controller.filterByMasteryLevel('Needs Improvement'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('تطبيق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
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
          Text('👨‍🎓', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('لا يوجد طلاب', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على طلاب',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
