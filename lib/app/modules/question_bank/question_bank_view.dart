import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/question_model.dart';
import 'question_bank_controller.dart';

class QuestionBankView extends GetView<QuestionBankController> {
  const QuestionBankView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'الاختبارات',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white),
            onPressed: controller.viewQuestionQuality,
            tooltip: 'تحليل الجودة',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterBottomSheet,
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
              // Search Bar
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

              // Active Filters
              if (controller.selectedDifficulty.value != null ||
                  controller.selectedChapter.value != null)
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
                              if (controller.selectedDifficulty.value != null)
                                _buildFilterChip(
                                  label: _getDifficultyLabel(
                                    controller.selectedDifficulty.value!,
                                  ),
                                  onDeleted: () =>
                                      controller.filterByDifficulty(null),
                                ),
                              if (controller.selectedChapter.value != null)
                                _buildFilterChip(
                                  label: controller.selectedChapter.value!,
                                  onDeleted: () =>
                                      controller.filterByChapter(null),
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
                ), // Questions Count
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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

              // Questions List
              Expanded(
                child: controller.filteredQuestions.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.filteredQuestions.length,
                        itemBuilder: (context, index) {
                          final question = controller.filteredQuestions[index];
                          return _buildQuestionCard(question);
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.questionText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildBadge(
                            label: question.chapter,
                            color: AppColors.primary,
                          ),
                          _buildBadge(
                            label: _getDifficultyLabel(question.difficulty),
                            color: _getDifficultyColor(question.difficulty),
                          ),
                          _buildBadge(
                            label: question.quality,
                            color: _getQualityColor(question.quality),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: const [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('تعديل'),
                        ],
                      ),
                      onTap: () => controller.editQuestion(question),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () => controller.deleteQuestion(question),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Question Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.trending_up,
                    label: 'معدل الصعوبة',
                    value:
                        '${(question.difficultyIndex * 100).toStringAsFixed(0)}%',
                  ),
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.bar_chart,
                    label: 'التمييز',
                    value:
                        '${(question.discriminationIndex * 100).toStringAsFixed(0)}%',
                  ),
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.repeat,
                    label: 'الاستخدام',
                    value: '${question.timesUsed}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelBold.copyWith(color: AppColors.primary),
        ),
      ],
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تصفية الأسئلة', style: AppTextStyles.h3),
            const SizedBox(height: 24),

            // Difficulty Filter
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
                  ),
                  _buildFilterOption(
                    label: 'متوسط',
                    isSelected: controller.selectedDifficulty.value == 'medium',
                    onTap: () => controller.filterByDifficulty('medium'),
                  ),
                  _buildFilterOption(
                    label: 'صعب',
                    isSelected: controller.selectedDifficulty.value == 'hard',
                    onTap: () => controller.filterByDifficulty('hard'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Chapter Filter
            Text('الفصل', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterOption(
                    label: 'الكل',
                    isSelected: controller.selectedChapter.value == null,
                    onTap: () => controller.filterByChapter(null),
                  ),
                  _buildFilterOption(
                    label: 'الجبر',
                    isSelected: controller.selectedChapter.value == 'الجبر',
                    onTap: () => controller.filterByChapter('الجبر'),
                  ),
                  _buildFilterOption(
                    label: 'الهندسة',
                    isSelected: controller.selectedChapter.value == 'الهندسة',
                    onTap: () => controller.filterByChapter('الهندسة'),
                  ),
                  _buildFilterOption(
                    label: 'حساب المثلثات',
                    isSelected:
                        controller.selectedChapter.value == 'حساب المثلثات',
                    onTap: () => controller.filterByChapter('حساب المثلثات'),
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

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'سهل';
      case 'medium':
        return 'متوسط';
      case 'hard':
        return 'صعب';
      default:
        return difficulty;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getQualityColor(String quality) {
    switch (quality) {
      case 'Excellent':
        return AppColors.success;
      case 'Good':
        return AppColors.info;
      case 'Fair':
        return AppColors.warning;
      case 'Poor':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('❓', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text('لا توجد أسئلة', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أسئلة',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
