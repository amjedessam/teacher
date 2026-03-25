import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
            onPressed: _showFilterBottomSheet,
            tooltip: 'تصفية',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.refreshStudents,
          child: Column(
            children: [
              // ── شريط البحث متصل بالـ AppBar ──────────────
              _buildSearchBar(),

              // ── الـ Filter chips النشطة ───────────────────
              Obx(() {
                final hasFilter =
                    controller.selectedClassId.value != null ||
                    controller.selectedMasteryLevel.value != null;
                if (!hasFilter) return const SizedBox.shrink();
                return _buildActiveFilters();
              }),

              // ── عداد الطلاب ───────────────────────────────
              Obx(() {
                if (controller.filteredStudents.isEmpty)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryBorder),
                        ),
                        child: Text(
                          '${controller.filteredStudents.length} طالب',
                          style: AppTextStyles.captionBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // ── قائمة الطلاب ──────────────────────────────
              Expanded(
                child: Obx(
                  () => controller.filteredStudents.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.filteredStudents.length,
                          itemBuilder: (context, index) {
                            return _buildStudentCard(
                              controller.filteredStudents[index],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── شريط البحث ───────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.searchStudents,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'ابحث عن طالب...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ── الـ Chips النشطة ─────────────────────────────────────
  Widget _buildActiveFilters() {
    return Container(
      color: AppColors.primarySurface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
                            (c) => c.id == controller.selectedClassId.value,
                          )
                          .name,
                      onDeleted: () => controller.filterByClass(null),
                    ),
                  if (controller.selectedMasteryLevel.value != null)
                    _buildFilterChip(
                      label: _getMasteryLevelLabel(
                        controller.selectedMasteryLevel.value!,
                      ),
                      onDeleted: () => controller.filterByMasteryLevel(null),
                    ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.close_rounded, size: 16),
            label: const Text('مسح'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.captionBold,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  // ── بطاقة الطالب ─────────────────────────────────────────
  Widget _buildStudentCard(StudentModel student) {
    final masteryColor = _getMasteryColor(student.masteryLevel);
    final scoreColor = student.averageScore > 0
        ? _getScoreColor(student.averageScore)
        : AppColors.textTertiary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.viewStudentDetail(student),
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withOpacity(0.04),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // ── Avatar ───────────────────────────────────
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                child: Center(
                  child:
                      student.profileImage.isNotEmpty &&
                          !student.profileImage.startsWith('http')
                      ? Text(
                          student.profileImage,
                          style: const TextStyle(fontSize: 26),
                        )
                      : Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // ── الاسم والفصل والمستوى ─────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: AppTextStyles.labelBold.copyWith(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.class_outlined,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          student.className,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    // مستوى الإتقان
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: masteryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: masteryColor.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        _getMasteryLevelLabel(student.masteryLevel),
                        style: AppTextStyles.caption.copyWith(
                          color: masteryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── المعدل + سهم ─────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: scoreColor.withOpacity(0.25)),
                    ),
                    child: Text(
                      student.averageScore > 0
                          ? '${student.averageScore.toStringAsFixed(1)}%'
                          : '—',
                      style: AppTextStyles.captionBold.copyWith(
                        color: scoreColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter Chip ──────────────────────────────────────────
  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close_rounded, size: 16),
        onDeleted: onDeleted,
        backgroundColor: AppColors.primarySurface,
        deleteIconColor: AppColors.primary,
        side: BorderSide(color: AppColors.primaryBorder),
        labelStyle: AppTextStyles.captionBold.copyWith(
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // ── Bottom Sheet الفلتر ───────────────────────────────────
  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text('تصفية الطلاب', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 20),

            // ── فلتر الفصل ───────────────────────────────
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
                    (c) => _buildFilterOption(
                      label: c.name,
                      isSelected: controller.selectedClassId.value == c.id,
                      onTap: () => controller.filterByClass(c.id),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),

            // ── فلتر مستوى الإتقان ────────────────────────
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
                    activeColor: AppColors.success,
                  ),
                  _buildFilterOption(
                    label: 'جيد',
                    isSelected:
                        controller.selectedMasteryLevel.value == 'Proficient',
                    onTap: () => controller.filterByMasteryLevel('Proficient'),
                    activeColor: AppColors.info,
                  ),
                  _buildFilterOption(
                    label: 'متوسط',
                    isSelected:
                        controller.selectedMasteryLevel.value == 'Developing',
                    onTap: () => controller.filterByMasteryLevel('Developing'),
                    activeColor: AppColors.warning,
                  ),
                  _buildFilterOption(
                    label: 'يحتاج تحسين',
                    isSelected:
                        controller.selectedMasteryLevel.value ==
                        'Needs Improvement',
                    onTap: () =>
                        controller.filterByMasteryLevel('Needs Improvement'),
                    activeColor: AppColors.error,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('تطبيق الفلتر'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── خيار الفلتر ──────────────────────────────────────────
  Widget _buildFilterOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    final color = activeColor ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.25),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.captionBold.copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────
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

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('👨‍🎓', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 20),
            Text('لا يوجد طلاب', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'لم يتم العثور على طلاب',
              style: AppTextStyles.bodyMedium.copyWith(
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
