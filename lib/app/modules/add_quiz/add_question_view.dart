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

              // ── الفصل ───────────────────────────────────────────────────
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

              // ══════════════════════════════════════════════════════════════
              // ── مهارة بلوم ─────────────────────────────────────────────
              // ══════════════════════════════════════════════════════════════
              _SkillSection(controller: controller),

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
            Radio<int>(
              value: index,
              groupValue: controller.correctOptionIndex.value,
              onChanged: (value) {
                if (value != null) controller.setCorrectOption(value);
              },
              activeColor: AppColors.success,
            ),
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

// ════════════════════════════════════════════════════════════════════════════
// ── _SkillSection — قسم مهارة بلوم ─────────────────────────────────────
// ════════════════════════════════════════════════════════════════════════════
class _SkillSection extends StatelessWidget {
  const _SkillSection({required this.controller});

  final AddQuestionController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── العنوان مع التوضيح ─────────────────────────────────────────
        Row(
          children: [
            Text('مهارة بلوم', style: AppTextStyles.labelBold),
            const SizedBox(width: 6),
            Text(
              '(تُستخدم في تحليلات الطالب)',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── الـ Dropdown + زر التحديد التلقائي ────────────────────────
        Row(
          children: [
            // Dropdown
            Expanded(
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedSkill.value.isEmpty
                      ? null
                      : controller.selectedSkill.value,
                  decoration: const InputDecoration(
                    hintText: '— اختر المهارة —',
                  ),
                  items: kSkillOptions
                      .map(
                        (skill) => DropdownMenuItem<String>(
                          value: skill.value,
                          child: Row(
                            children: [
                              Text(
                                skill.emoji,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(skill.label),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedSkill.value = value ?? '';
                    controller.skillError.value = '';
                  },
                ),
              ),
            ),

            const SizedBox(width: 10),

            // زر التحديد التلقائي
            Obx(
              () => _AutoDetectButton(
                isLoading: controller.skillLoading.value,
                onPressed: controller.detectSkill,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── رسالة الخطأ ────────────────────────────────────────────────
        Obx(() {
          if (controller.skillError.value.isEmpty) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    controller.skillError.value,
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // ── Badge المهارة المحددة ───────────────────────────────────────
        Obx(() {
          if (controller.skillLoading.value) {
            return _SkillDetectingIndicator();
          }
          if (controller.selectedSkill.value.isEmpty) return const SizedBox();

          final skill = findSkill(controller.selectedSkill.value);
          if (skill == null) return const SizedBox();

          return _SkillBadge(skill: skill);
        }),
      ],
    );
  }
}

// ── زر التحديد التلقائي ─────────────────────────────────────────────────
class _AutoDetectButton extends StatelessWidget {
  const _AutoDetectButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? Colors.grey.shade200
              : const Color(0xFF7C3AED),
          foregroundColor: isLoading ? Colors.grey : Colors.white,
          elevation: isLoading ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'جارٍ...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.auto_awesome_rounded, size: 16),
                  SizedBox(width: 4),
                  Text('تلقائي', style: TextStyle(fontSize: 13)),
                ],
              ),
      ),
    );
  }
}

// ── مؤشر أثناء التحديد ─────────────────────────────────────────────────
class _SkillDetectingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'يتم تحليل السؤال...',
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF7C3AED),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Badge المهارة بعد التحديد ────────────────────────────────────────────
class _SkillBadge extends StatelessWidget {
  const _SkillBadge({required this.skill});

  final SkillOption skill;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(skill.value),
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: skill.bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: skill.color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 15, color: skill.color),
            const SizedBox(width: 6),
            Text(
              'تم التحديد:',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${skill.emoji} ${skill.label}',
              style: AppTextStyles.caption.copyWith(
                color: skill.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
