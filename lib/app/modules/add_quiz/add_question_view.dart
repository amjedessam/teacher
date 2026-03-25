import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'add_question_controller.dart';

class AddQuestionView extends GetView<AddQuestionController> {
  const AddQuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('إضافة سؤال جديد', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── نص السؤال ───────────────────────────────────────────────
              Text('نص السؤال', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.questionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'اكتب السؤال هنا...',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'يرجى إدخال نص السؤال'
                    : null,
              ),

              const SizedBox(height: 24),

              // ── المادة ──────────────────────────────────────────────────
              Text('المادة', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedSubjectId.value,
                  decoration: const InputDecoration(),
                  hint: const Text('اختر المادة'),
                  items: controller.subjects
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c.subjectId,
                          child: Text(c.subject),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      controller.selectedSubjectId.value = value,
                  validator: (v) => v == null ? 'يرجى اختيار المادة' : null,
                ),
              ),

              const SizedBox(height: 24),

              // ── الفصل (ديناميكي من DB) ───────────────────────────────
              Text('الفصل', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.chapters.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          controller.selectedSubjectId.value == null
                              ? 'اختر المادة أولاً'
                              : 'جارٍ تحميل الفصول...',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return DropdownButtonFormField<int>(
                  value: controller.selectedChapterId.value,
                  decoration: const InputDecoration(),
                  hint: const Text('اختر الفصل'),
                  items: controller.chapters
                      .map(
                        (ch) => DropdownMenuItem<int>(
                          value: ch.id,
                          child: Text(ch.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      controller.selectedChapterId.value = value,
                  validator: (v) => v == null ? 'يرجى اختيار الفصل' : null,
                );
              }),

              const SizedBox(height: 24),

              // ── نوع السؤال + الصعوبة ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('نوع السؤال', style: AppTextStyles.labelBold),
                        const SizedBox(height: 12),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedQuestionType.value,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(
                                value: 'mcq',
                                child: Text('اختيار متعدد'),
                              ),
                              DropdownMenuItem(
                                value: 'true_false',
                                child: Text('صح / خطأ'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedQuestionType.value = value;
                                // إذا صح/خطأ → ضبط الخيارات تلقائياً
                                if (value == 'true_false') {
                                  controller.options.value = ['صح', 'خطأ'];
                                  controller.correctOptionIndex.value = 0;
                                } else {
                                  controller.options.value = ['', '', '', ''];
                                  controller.correctOptionIndex.value = 0;
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الصعوبة', style: AppTextStyles.labelBold),
                        const SizedBox(height: 12),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedDifficulty.value,
                            decoration: const InputDecoration(),
                            items: const [
                              DropdownMenuItem(
                                value: 'easy',
                                child: Text('سهل'),
                              ),
                              DropdownMenuItem(
                                value: 'medium',
                                child: Text('متوسط'),
                              ),
                              DropdownMenuItem(
                                value: 'hard',
                                child: Text('صعب'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedDifficulty.value = value;
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

              // ── الخيارات ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الخيارات', style: AppTextStyles.labelBold),
                  Text(
                    'اضغط على ○ لتحديد الإجابة الصحيحة',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(
                () => Column(
                  children: List.generate(
                    controller.options.length,
                    (index) => _buildOptionField(index),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Obx(
                () =>
                    controller.options.length < 6 &&
                        controller.selectedQuestionType.value != 'true_false'
                    ? OutlinedButton.icon(
                        onPressed: controller.addOption,
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة خيار'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      )
                    : const SizedBox(),
              ),

              const SizedBox(height: 24),

              // ── الشرح ───────────────────────────────────────────────────
              Text(
                'شرح الإجابة الصحيحة (اختياري)',
                style: AppTextStyles.labelBold,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.explanationController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'اشرح لماذا هذه الإجابة صحيحة...',
                ),
              ),

              const SizedBox(height: 32),

              // ── زر الحفظ ────────────────────────────────────────────────
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveQuestion,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      controller.isLoading.value
                          ? 'جارٍ الحفظ...'
                          : 'حفظ السؤال',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(int index) {
    return Obx(() {
      final isCorrect = controller.correctOptionIndex.value == index;
      final isTrueFalse = controller.selectedQuestionType.value == 'true_false';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.success.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCorrect ? AppColors.success : AppColors.border,
            width: isCorrect ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // راديو لاختيار الإجابة الصحيحة
            Radio<int>(
              value: index,
              groupValue: controller.correctOptionIndex.value,
              onChanged: (value) {
                if (value != null) controller.setCorrectOption(value);
              },
              activeColor: AppColors.success,
            ),

            // حقل الإدخال — للصح/خطأ يكون للقراءة فقط
            Expanded(
              child: isTrueFalse
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        controller.options[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isCorrect
                              ? AppColors.success
                              : AppColors.textPrimary,
                          fontWeight: isCorrect
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    )
                  : TextFormField(
                      initialValue: controller.options[index],
                      decoration: InputDecoration(
                        hintText: 'الخيار ${index + 1}',
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) =>
                          controller.updateOption(index, value),
                    ),
            ),

            // أيقونة الإجابة الصحيحة أو حذف
            if (isCorrect)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
              )
            else if (!isTrueFalse && controller.options.length > 2)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                onPressed: () => controller.removeOption(index),
              ),
          ],
        ),
      );
    });
  }
}
