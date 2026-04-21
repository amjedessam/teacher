import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'quiz_builder_controller.dart';

class QuizBuilderView extends GetView<QuizBuilderController> {
  const QuizBuilderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.goBack,
          ),
          title: Text(_stepTitle(), style: AppTextStyles.h3),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: _buildStepIndicator(),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  String _stepTitle() {
    switch (controller.currentStep.value) {
      case 0:
        return controller.isStudentMode
            ? 'اختبار فردي — الإعدادات'
            : 'إعدادات الاختبار';
      case 1:
        return 'اختيار الأسئلة';
      case 2:
        return 'مراجعة وإنشاء';
      default:
        return '';
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(
        3,
        (i) => Expanded(
          child: Container(
            height: 4,
            color: i <= controller.currentStep.value
                ? AppColors.primary
                : AppColors.border,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      default:
        return const SizedBox();
    }
  }

  // ── Step 0: إعدادات الاختبار ─────────────────────────────────────────────
  Widget _buildStep0() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── بانر وضع الطالب الفردي ────────────────────────────────────
              if (controller.isStudentMode) ...[
                Obx(
                  () => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person_pin_outlined,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'اختبار فردي',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'سيُرسَل هذا الاختبار إلى: ${controller.targetStudentName.value}',
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // عنوان الاختبار
              Text('عنوان الاختبار', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  hintText: 'مثال: اختبار الوحدة الأولى',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'يرجى إدخال عنوان' : null,
              ),

              const SizedBox(height: 20),

              // الوصف
              Text('الوصف (اختياري)', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'وصف مختصر للاختبار...',
                ),
              ),

              const SizedBox(height: 20),

              // المادة
              Text('المادة', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedSubjectId.value,
                  decoration: const InputDecoration(),
                  hint: const Text('اختر المادة'),
                  items: controller.subjects
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.subjectId,
                          child: Text(c.subject),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => controller.selectedSubjectId.value = v,
                  validator: (v) => v == null ? 'يرجى اختيار المادة' : null,
                ),
              ),

              const SizedBox(height: 20),

              // القسم — يُخفى في وضع الطالب الفردي لأنه مُحدد تلقائياً
              if (!controller.isStudentMode) ...[
                Text('القسم', style: AppTextStyles.labelBold),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.sections.isEmpty) {
                    return _loadingDropdown('اختر المادة أولاً');
                  }
                  return DropdownButtonFormField<int>(
                    value: controller.selectedSectionId.value,
                    decoration: const InputDecoration(),
                    hint: const Text('اختر القسم'),
                    items: controller.sections
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => controller.selectedSectionId.value = v,
                    validator: (v) => v == null ? 'يرجى اختيار القسم' : null,
                  );
                }),
                const SizedBox(height: 20),
              ],

              // فلتر الوحدة (اختياري)
              Text('تصفية حسب الفصل (اختياري)', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.chapters.isEmpty) {
                  return _loadingDropdown('جارٍ التحميل...');
                }
                return DropdownButtonFormField<int?>(
                  value: controller.selectedChapterId.value,
                  decoration: const InputDecoration(),
                  hint: const Text('كل الفصول'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('كل الفصول'),
                    ),
                    ...controller.chapters.map(
                      (ch) =>
                          DropdownMenuItem(value: ch.id, child: Text(ch.name)),
                    ),
                  ],
                  onChanged: (v) => controller.selectedChapterId.value = v,
                );
              }),

              const SizedBox(height: 20),

              // الصعوبة (اختياري)
              Text('مستوى الصعوبة (اختياري)', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String?>(
                  value: controller.selectedDifficulty.value,
                  decoration: const InputDecoration(),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('كل المستويات')),
                    DropdownMenuItem(value: 'easy', child: Text('سهل')),
                    DropdownMenuItem(value: 'medium', child: Text('متوسط')),
                    DropdownMenuItem(value: 'hard', child: Text('صعب')),
                  ],
                  onChanged: (v) => controller.selectedDifficulty.value = v,
                ),
              ),

              const SizedBox(height: 20),

              // المدة + درجة النجاح
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المدة (دقيقة)', style: AppTextStyles.labelBold),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.durationController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            suffixText: 'دقيقة',
                          ),
                          validator: (v) =>
                              (v == null || int.tryParse(v) == null)
                              ? 'رقم صحيح فقط'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('درجة النجاح %', style: AppTextStyles.labelBold),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.passingMarksController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(suffixText: '%'),
                          validator: (v) =>
                              (v == null || int.tryParse(v) == null)
                              ? 'رقم صحيح فقط'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text('الفصل الدراسي', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedSemesterId.value,
                  decoration: const InputDecoration(),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('الفصل الأول')),
                    DropdownMenuItem(value: 2, child: Text('الفصل الثاني')),
                  ],
                  onChanged: (v) {
                    if (v != null) controller.selectedSemesterId.value = v;
                  },
                ),
              ),

              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoadingQuestions.value
                        ? null
                        : controller.goToSelectQuestions,
                    icon: controller.isLoadingQuestions.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: const Text('التالي: اختيار الأسئلة'),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  // ── Step 1: اختيار الأسئلة ───────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      children: [
        // شريط الإحصاء
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.allQuestions.length} سؤال متاح',
                  style: AppTextStyles.bodyMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'تم اختيار ${controller.selectedQuestionIds.length}',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // قائمة الأسئلة
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.allQuestions.length,
              itemBuilder: (context, index) {
                final q = controller.allQuestions[index];
                return _buildQuestionCard(q);
              },
            ),
          ),
        ),

        // ✅ الأزرار في الأسفل - جنباً إلى جنب
        Obx(
          () => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // // ── زر التوليد الذكي ───────────────────────
                // Expanded(
                //   flex: 2,
                //   child: Obx(
                //     () => OutlinedButton.icon(
                //       onPressed: controller.isGeneratingQuestions.value
                //           ? null
                //           : controller.generateQuestionsByAI,
                //       icon: controller.isGeneratingQuestions.value
                //           ? const SizedBox(
                //               width: 18,
                //               height: 18,
                //               child: CircularProgressIndicator(strokeWidth: 2),
                //             )
                //           : const Icon(Icons.smart_toy_outlined, size: 20),
                //       label: const Text(
                //         'توليد ذكي',
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       style: OutlinedButton.styleFrom(
                //         padding: const EdgeInsets.symmetric(vertical: 14),
                //         side: BorderSide(color: AppColors.primary, width: 1.5),
                //         foregroundColor: AppColors.primary,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(width: 12),

                // ── زر سؤال جديد ────────────────────────
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: controller.addNewQuestion,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      'سؤال جديد',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.primary, width: 1.5),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ── زر المراجعة ────────────────────────
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: controller.selectedQuestionIds.isEmpty
                        ? null
                        : controller.goToReview,
                    icon: const Icon(Icons.arrow_forward, size: 20),
                    label: Text(
                      'مراجعة (${controller.selectedQuestionIds.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      disabledBackgroundColor: AppColors.border,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(q) {
    return Obx(() {
      final selected = controller.isSelected(q.id);
      return GestureDetector(
        onTap: () => controller.toggleQuestion(q.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),

              // نص السؤال + بادجات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.questionText,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _badge(
                          controller.difficultyLabel(q.difficulty),
                          controller.difficultyColor(q.difficulty),
                        ),
                        const SizedBox(width: 8),
                        _badge(
                          q.questionType == 'mcq' ? 'اختيار متعدد' : 'صح/خطأ',
                          AppColors.info,
                        ),
                        if (q.chapter.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _badge(q.chapter, AppColors.textSecondary),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Step 2: مراجعة وإنشاء ────────────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 20),

                Text(
                  'الأسئلة المختارة (${controller.selectedQuestions.length})',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 12),

                ...controller.selectedQuestions.asMap().entries.map(
                  (entry) =>
                      _buildReviewQuestionItem(entry.key + 1, entry.value),
                ),
              ],
            ),
          ),
        ),

        // زر الإنشاء
        Obx(
          () => Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.saveExam,
                icon: controller.isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  controller.isSaving.value
                      ? 'جارٍ الإنشاء...'
                      : controller.isStudentMode
                      ? 'إنشاء وإرسال إلى ${controller.targetStudentName.value}'
                      : 'إنشاء الاختبار للفصل',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isStudentMode
                      ? Colors.blue.shade600
                      : AppColors.success,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          // بادج نوع الاختبار
          if (controller.isStudentMode) ...[
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_pin_outlined,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'اختبار فردي — ${controller.targetStudentName.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 14, color: AppColors.info),
                  const SizedBox(width: 4),
                  Text(
                    'اختبار الفصل',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          Text(controller.titleController.text, style: AppTextStyles.h4),
          if (controller.descriptionController.text.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              controller.descriptionController.text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem(
                icon: Icons.quiz_outlined,
                label: 'عدد الأسئلة',
                value: '${controller.selectedQuestions.length}',
                color: AppColors.primary,
              ),
              _summaryItem(
                icon: Icons.star_outline,
                label: 'الدرجة الكلية',
                value: '${controller.totalMarks}',
                color: AppColors.warning,
              ),
              _summaryItem(
                icon: Icons.timer_outlined,
                label: 'المدة',
                value: '${controller.durationController.text} دقيقة',
                color: AppColors.info,
              ),
              _summaryItem(
                icon: Icons.check_circle_outline,
                label: 'درجة النجاح',
                value: '${controller.passingMarksController.text}%',
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.labelBold.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildReviewQuestionItem(int order, q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$order',
                style: AppTextStyles.labelBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.questionText,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _badge(
                      controller.difficultyLabel(q.difficulty),
                      controller.difficultyColor(q.difficulty),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _loadingDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        hint,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
