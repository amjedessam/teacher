import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'quiz_builder_controller.dart';

class QuizBuilderView extends GetView<QuizBuilderController> {
  const QuizBuilderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('بناء اختبار', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isPreviewMode.value) {
          return _buildPreviewMode();
        }
        return _buildBuilderMode();
      }),
    );
  }

  Widget _buildBuilderMode() {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'قم ببناء اختبار مخصص للطلاب مع اختيار نسب الصعوبة',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text('الفصل الدراسي', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedClassId.value,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.class_),
                ),
                items: controller.classes
                    .map(
                      (classItem) => DropdownMenuItem(
                        value: classItem.id,
                        child: Text(classItem.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  controller.selectedClassId.value = value;
                },
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الفصل', style: AppTextStyles.labelBold),
                      const SizedBox(height: 12),

                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedChapter.value,
                          decoration: const InputDecoration(),
                          isExpanded: true,
                          items: ['الجبر', 'الهندسة', 'حساب المثلثات']
                              .map(
                                (chapter) => DropdownMenuItem(
                                  value: chapter,
                                  child: Text(
                                    chapter,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedChapter.value = value;
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 5),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedUnit.value,
                          decoration: const InputDecoration(),
                          isExpanded: true,
                          items:
                              [
                                    'المعادلات الخطية',
                                    'المعادلات التربيعية',
                                    'المتتاليات',
                                  ]
                                  .map(
                                    (unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(
                                        unit,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedUnit.value = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text('عدد الأسئلة', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('عدد الأسئلة:', style: AppTextStyles.bodyMedium),
                        Text(
                          '${controller.questionCount.value}',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: controller.questionCount.value.toDouble(),
                      min: 5,
                      max: 50,
                      divisions: 9,
                      label: '${controller.questionCount.value}',
                      onChanged: controller.updateQuestionCount,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text('توزيع الصعوبة', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),

            _buildDifficultySlider(
              label: 'سهل',
              color: AppColors.success,
              value: controller.easyPercentage,
              onChanged: controller.updateEasyPercentage,
            ),

            const SizedBox(height: 16),

            _buildDifficultySlider(
              label: 'متوسط',
              color: AppColors.warning,
              value: controller.mediumPercentage,
              onChanged: controller.updateMediumPercentage,
            ),

            const SizedBox(height: 16),

            _buildDifficultySlider(
              label: 'صعب',
              color: AppColors.error,
              value: controller.hardPercentage,
              onChanged: controller.updateHardPercentage,
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'ملخص الاختبار',
                    style: AppTextStyles.h4.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => _buildSummaryItem(
                          '${((controller.questionCount.value * controller.easyPercentage.value) / 100).round()}',
                          'سهل',
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.white30),
                      Obx(
                        () => _buildSummaryItem(
                          '${((controller.questionCount.value * controller.mediumPercentage.value) / 100).round()}',
                          'متوسط',
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.white30),
                      Obx(
                        () => _buildSummaryItem(
                          '${((controller.questionCount.value * controller.hardPercentage.value) / 100).round()}',
                          'صعب',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: controller.isGenerating.value
                      ? null
                      : controller.generateQuiz,
                  icon: controller.isGenerating.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    controller.isGenerating.value
                        ? 'جاري توليد الاختبار...'
                        : 'توليد الاختبار',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySlider({
    required String label,
    required Color color,
    required RxInt value,
    required Function(double) onChanged,
  }) {
    return Obx(
      () => Container(
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
                Text(label, style: AppTextStyles.bodyMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${value.value}%',
                    style: AppTextStyles.labelBold.copyWith(color: color),
                  ),
                ),
              ],
            ),
            Slider(
              value: value.value.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: color,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewMode() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('معاينة الاختبار', style: AppTextStyles.h4),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.generatedQuestions.length} سؤال',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: controller.backToBuilder,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'تعديل',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.exportToPDF,
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: const Text('تصدير PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.sendToStudents,
                      icon: const Icon(Icons.send),
                      label: const Text('إرسال للطلاب'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.generatedQuestions.length,
              itemBuilder: (context, index) {
                final question = controller.generatedQuestions[index];
                return _buildQuestionPreviewCard(question, index + 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionPreviewCard(question, int number) {
    final difficultyColor = _getDifficultyColor(question.difficulty);

    const List<String> optionLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: difficultyColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: difficultyColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: difficultyColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getDifficultyLabel(question.difficulty),
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
              children: question.options.asMap().entries.map<Widget>((entry) {
                final index = entry.key;
                final option = entry.value;

                final letter = (index < optionLetters.length)
                    ? optionLetters[index]
                    : '?';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: option.isCorrect
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: option.isCorrect
                          ? AppColors.success
                          : AppColors.border,
                      width: option.isCorrect ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: option.isCorrect
                              ? AppColors.success
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: option.isCorrect
                                ? AppColors.success
                                : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: option.isCorrect
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option.text,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      if (option.isCorrect)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
}
