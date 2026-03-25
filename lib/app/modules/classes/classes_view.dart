import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.refreshClasses,
          child: Column(
            children: [
              // ── شريط البحث ───────────────────────────────────
              _buildSearchBar(),

              // ── عداد الفصول ──────────────────────────────────
              Obx(() {
                if (controller.filteredClasses.isEmpty)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                          '${controller.filteredClasses.length} فصول',
                          style: AppTextStyles.captionBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // ── قائمة الفصول ─────────────────────────────────
              Expanded(
                child: Obx(
                  () => controller.filteredClasses.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.filteredClasses.length,
                          itemBuilder: (context, index) {
                            return _buildClassCard(
                              controller.filteredClasses[index],
                              index,
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
          onChanged: controller.searchClasses,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'ابحث عن فصل...',
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

  // ── بطاقة الفصل ──────────────────────────────────────────
  Widget _buildClassCard(ClassModel classItem, int index) {
    // استخدام الـ smart mapper بدل اللون العشوائي من DB
    final color = AppColors.getClassColor(classItem.color);

    // كل فصل يأخذ لوناً مختلفاً من الـ palette تلقائياً
    final paletteColors = [
      AppColors.primary,
      AppColors.secondary,
      const Color(0xFF7C3AED),
      AppColors.accent,
      AppColors.success,
      const Color(0xFF0891B2),
    ];
    final cardColor = paletteColors[index % paletteColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
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
        onTap: () => controller.viewClassDetails(classItem),
        borderRadius: BorderRadius.circular(18),
        splashColor: cardColor.withOpacity(0.05),
        highlightColor: cardColor.withOpacity(0.03),
        child: Column(
          children: [
            // ── Header البطاقة ────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  // أيقونة الفصل
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: cardColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cardColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        classItem.icon,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // اسم الفصل والمرحلة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classItem.name,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 13,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              classItem.grade,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // متوسط الدرجات + سهم
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() {
                        final avg = controller.getClassAvgScore(classItem.id);
                        final scoreColor = avg > 0
                            ? _getScoreColor(avg)
                            : AppColors.textTertiary;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: scoreColor.withOpacity(0.25),
                            ),
                          ),
                          child: Text(
                            avg > 0 ? '${avg.toStringAsFixed(1)}%' : '—',
                            style: AppTextStyles.captionBold.copyWith(
                              color: scoreColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Footer البطاقة — إحصائيات ────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // الطلاب
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.people_alt_outlined,
                      label: 'الطلاب',
                      value: '${classItem.totalStudents}',
                      color: cardColor,
                    ),
                  ),
                  Container(width: 1, height: 32, color: AppColors.divider),
                  // الاختبارات
                  Expanded(
                    child: Obx(
                      () => _buildStatItem(
                        icon: Icons.quiz_outlined,
                        label: 'الاختبارات',
                        value: '${controller.getClassExamCount(classItem.id)}',
                        color: cardColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── عنصر الإحصائية ───────────────────────────────────────
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.labelBold.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── لون الدرجة ───────────────────────────────────────────
  Color _getScoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  // ── حالة فارغة ───────────────────────────────────────────
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
                child: Text('📚', style: TextStyle(fontSize: 42)),
              ),
            ),
            const SizedBox(height: 20),
            Text('لا توجد فصول', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'لم يتم العثور على فصول دراسية',
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
