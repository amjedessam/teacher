import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/question_model.dart';
import '../../routes/app_routes.dart';
import 'question_bank_controller.dart';

class QuestionBankView extends GetView<QuestionBankController> {
  const QuestionBankView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'بنك الأسئلة',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white),
            onPressed: () => Get.toNamed(AppRoutes.questionQuality),
            tooltip: 'جودة الأسئلة',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.addNewQuestion,
        icon: const Icon(Icons.add),
        label: const Text('إضافة سؤال'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.refreshQuestions,
          child: Column(
            children: [
              // ── شريط البحث ──────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: controller.searchQuestions,
                  decoration: InputDecoration(
                    hintText: 'ابحث في الأسئلة...',
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

              // ── الفلاتر النشطة ───────────────────────────
              Obx(() {
                if (!controller.hasActiveFilters)
                  return const SizedBox.shrink();
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (controller.selectedSubjectId.value != null)
                                _buildActiveChip(
                                  label:
                                      controller.availableSubjects.firstWhere(
                                        (s) =>
                                            s['id'] ==
                                            controller.selectedSubjectId.value,
                                        orElse: () => {'name': ''},
                                      )['name'] ??
                                      '',
                                  onDeleted: () =>
                                      controller.filterBySubject(null),
                                ),
                              if (controller.selectedDifficulty.value != null)
                                _buildActiveChip(
                                  label: controller.getDifficultyLabel(
                                    controller.selectedDifficulty.value!,
                                  ),
                                  onDeleted: () =>
                                      controller.filterByDifficulty(null),
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: controller.clearFilters,
                        child: const Text('مسح الكل'),
                      ),
                    ],
                  ),
                );
              }),

              // ── عداد النتائج ─────────────────────────────
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'إجمالي الأسئلة: ${controller.filteredQuestions.length}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── قائمة الأسئلة ────────────────────────────
              Expanded(
                child: Obx(
                  () => controller.filteredQuestions.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                          itemCount: controller.filteredQuestions.length,
                          itemBuilder: (context, index) {
                            return _buildQuestionCard(
                              controller.filteredQuestions[index],
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

  // ── بطاقة السؤال ──────────────────────────────────────────
  Widget _buildQuestionCard(QuestionModel question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // نص السؤال
                      Text(
                        question.questionText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Badges
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          // المادة
                          _buildBadge(
                            label: question.subject,
                            color: AppColors.primary,
                            icon: Icons.book_outlined,
                          ),
                          // الصعوبة
                          _buildBadge(
                            label: controller.getDifficultyLabel(
                              question.difficulty,
                            ),
                            color: controller.getDifficultyColor(
                              question.difficulty,
                            ),
                          ),
                          // النوع
                          _buildBadge(
                            label: controller.getTypeLabel(
                              question.questionType,
                            ),
                            color: AppColors.info,
                          ),
                          // المنشئ
                          _buildBadge(
                            label: question.createdByTeacherName ?? 'الأدمن',
                            color: AppColors.textSecondary,
                            icon: Icons.person_outline,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // قائمة الخيارات
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => controller.editQuestion(question),
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => controller.deleteQuestion(question),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // إحصائيات الاستخدام
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildStatItem(
                  icon: Icons.repeat_rounded,
                  label: 'استُخدم',
                  value: '${question.timesUsed}',
                  color: AppColors.primary,
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.check_circle_outline,
                  label: 'أجاب صح',
                  value: '${question.timesCorrect}',
                  color: const Color(0xFF4CAF50),
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.cancel_outlined,
                  label: 'أخطأ',
                  value: '${question.timesIncorrect}',
                  color: const Color(0xFFF44336),
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.percent_rounded,
                  label: 'نجاح',
                  value: () {
                    final total =
                        question.timesCorrect + question.timesIncorrect;
                    if (total == 0) return '—';
                    return '${(question.timesCorrect / total * 100).toStringAsFixed(0)}%';
                  }(),
                  color: () {
                    final total =
                        question.timesCorrect + question.timesIncorrect;
                    if (total == 0) return AppColors.textSecondary;
                    final rate = question.timesCorrect / total;
                    return rate >= 0.7
                        ? const Color(0xFF4CAF50)
                        : rate >= 0.4
                        ? const Color(0xFFFF9800)
                        : const Color(0xFFF44336);
                  }(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Container(width: 1, height: 32, color: AppColors.border);

  Widget _buildActiveChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        deleteIconColor: AppColors.primary,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
      ),
    );
  }

  // ── Bottom Sheet الفلاتر ──────────────────────────────────
  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('تصفية الأسئلة', style: AppTextStyles.h3),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                    child: const Text('مسح الكل'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── فلتر المادة ──────────────────────────────
              Text('المادة', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterOption(
                      label: 'الكل',
                      isSelected: controller.selectedSubjectId.value == null,
                      onTap: () => controller.filterBySubject(null),
                    ),
                    ...controller.availableSubjects.map(
                      (s) => _buildFilterOption(
                        label: s['name']!,
                        isSelected:
                            controller.selectedSubjectId.value == s['id'],
                        onTap: () => controller.filterBySubject(s['id']),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── فلتر الصعوبة ─────────────────────────────
              Text('مستوى الصعوبة', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterOption(
                      label: 'الكل',
                      isSelected: controller.selectedDifficulty.value == null,
                      onTap: () => controller.filterByDifficulty(null),
                    ),
                    _buildFilterOption(
                      label: 'سهل',
                      isSelected: controller.selectedDifficulty.value == 'easy',
                      onTap: () => controller.filterByDifficulty('easy'),
                      color: const Color(0xFF4CAF50),
                    ),
                    _buildFilterOption(
                      label: 'متوسط',
                      isSelected:
                          controller.selectedDifficulty.value == 'medium',
                      onTap: () => controller.filterByDifficulty('medium'),
                      color: const Color(0xFFFF9800),
                    ),
                    _buildFilterOption(
                      label: 'صعب',
                      isSelected: controller.selectedDifficulty.value == 'hard',
                      onTap: () => controller.filterByDifficulty('hard'),
                      color: const Color(0xFFF44336),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('تطبيق'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? c : c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? c : c.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : c,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('❓', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('لا توجد أسئلة', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أسئلة تطابق البحث',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
