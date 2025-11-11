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
              // Question Text
              Text('نص السؤال', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.questionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'اكتب السؤال هنا...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال نص السؤال';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Chapter & Difficulty Row
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
                            items:
                                ['الجبر', 'الهندسة', 'حساب المثلثات', 'الإحصاء']
                                    .map(
                                      (chapter) => DropdownMenuItem(
                                        value: chapter,
                                        child: Text(chapter),
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
                            items: [
                              const DropdownMenuItem(
                                value: 'easy',
                                child: Text('سهل'),
                              ),
                              const DropdownMenuItem(
                                value: 'medium',
                                child: Text('متوسط'),
                              ),
                              const DropdownMenuItem(
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

              // Options
              Text('الخيارات', style: AppTextStyles.labelBold),
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

              if (controller.options.length < 6)
                OutlinedButton.icon(
                  onPressed: controller.addOption,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة خيار'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),

              const SizedBox(height: 24),

              // Explanation
              Text('شرح الإجابة الصحيحة', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.explanationController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'اشرح لماذا هذه الإجابة صحيحة...',
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveQuestion,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('حفظ السؤال'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionField(int index) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: controller.correctOptionIndex.value == index
              ? AppColors.success.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.correctOptionIndex.value == index
                ? AppColors.success
                : AppColors.border,
            width: controller.correctOptionIndex.value == index ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: controller.correctOptionIndex.value,
              onChanged: (value) {
                if (value != null) {
                  controller.setCorrectOption(value);
                }
              },
              activeColor: AppColors.success,
            ),
            Expanded(
              child: TextFormField(
                initialValue: controller.options[index],
                decoration: InputDecoration(
                  hintText: 'الخيار ${index + 1}',
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: (value) => controller.updateOption(index, value),
              ),
            ),
            if (controller.options.length > 2)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => controller.removeOption(index),
              ),
          ],
        ),
      ),
    );
  }
}
