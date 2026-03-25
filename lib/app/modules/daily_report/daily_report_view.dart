import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/core/theme/app_colors.dart';
import 'package:teacher/app/core/theme/app_text_styles.dart';
import 'daily_report_controller.dart';

class DailyReportView extends GetView<DailyReportController> {
  const DailyReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('الخلاصة اليومية والأنشطة', style: AppTextStyles.h3),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      // ✅ التعديل الرئيسي هنا في الـ body
      body: Obx(() {
        if (controller.isLoadingSections.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ✅ إذا لم توجد فصول، نعرض شاشة فارغة مع رسالة
        if (controller.sectionOptions.isEmpty) {
          return Column(
            children: [
              _buildSectionSelector(),
              const SizedBox(height: 60),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open_outlined,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'لا توجد فصول مسندة',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'قم بإضافة فصول من الإعدادات',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // ✅ إذا كانت موجودة، نعرض الواجهة الكاملة
        return Column(
          children: [
            _buildSectionSelector(),
            _buildTabBar(),
            Expanded(
              child: Obx(
                () => controller.selectedTab.value == 0
                    ? _buildActivityTab(context)
                    : _buildSummaryTab(),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── اختيار الفصل والمادة ────────────────────────────────────────────────
  Widget _buildSectionSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Obx(() {
        // ✅ إذا كانت القائمة فارغة، نعرض رسالة تنبيه
        if (controller.sectionOptions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'لا توجد فصول مسندة لك حالياً',
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // ✅ إذا كانت القائمة غير فارغة، نعرض الـ Dropdown
        return DropdownButtonFormField<SectionSubjectOption>(
          value: controller.selectedOption.value,
          decoration: InputDecoration(
            labelText: 'الفصل والمادة',
            prefixIcon: const Icon(Icons.class_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: controller.sectionOptions.map((opt) {
            return DropdownMenuItem(
              value: opt,
              child: Text(opt.displayName, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) controller.selectedOption.value = v;
          },
        );
      }),
    );
  }

  // ── Tab Bar ──────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: _buildTab(0, Icons.assignment_outlined, 'نشاط / واجب'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTab(1, Icons.summarize_outlined, 'خلاصة اليوم'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.selectedTab.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 0: نشاط / واجب
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildActivityTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بانر توضيحي
          _buildInfoBanner(
            icon: Icons.people_outline,
            text: 'سيُرسل هذا النشاط لجميع اولياء امور الطلاب للفصل المختار',
            color: AppColors.info,
          ),
          const SizedBox(height: 20),

          // عنوان النشاط
          Text('عنوان النشاط', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.activityTitleController,
            decoration: const InputDecoration(
              hintText: 'مثال: حل تمارين الوحدة الثالثة',
            ),
          ),
          const SizedBox(height: 16),

          // الوصف
          Text('الوصف (اختياري)', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.activityDescController,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'تفاصيل إضافية...'),
          ),
          const SizedBox(height: 16),

          // نوع النشاط
          Text('نوع النشاط', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              children: ['homework', 'project', 'reading', 'practice'].map((
                type,
              ) {
                final isSelected =
                    controller.selectedActivityType.value == type;
                return ChoiceChip(
                  label: Text(controller.activityTypeLabel(type)),
                  selected: isSelected,
                  onSelected: (_) =>
                      controller.selectedActivityType.value = type,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // الأولوية
          Text('الأولوية', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              children: List.generate(5, (i) {
                final level = i + 1;
                final isActive = level <= controller.selectedPriority.value;
                return GestureDetector(
                  onTap: () => controller.selectedPriority.value = level,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? _priorityColor(level)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? _priorityColor(level)
                            : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$level',
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // تاريخ التسليم
          Text('تاريخ التسليم', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          Obx(
            () => GestureDetector(
              // ✅ تعديل: إزالة context من الاستدعاء
              onTap: controller.pickDueDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      controller.selectedDueDate.value != null
                          ? controller.formatDate(
                              controller.selectedDueDate.value!,
                            )
                          : 'اختر التاريخ',
                      style: TextStyle(
                        color: controller.selectedDueDate.value != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, size: 24),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // زر الإرسال
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: controller.isSavingActivity.value
                    ? null
                    : controller.saveActivity,
                icon: controller.isSavingActivity.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(
                  controller.isSavingActivity.value
                      ? 'جارٍ الإرسال...'
                      : 'إرسال النشاط للفصل',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1: خلاصة اليوم
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بانر توضيحي
          _buildInfoBanner(
            icon: Icons.people_outline,
            text:
                'سيتم إرسال هذه الخلاصة لجميع اولياء امور الطلاب للفصل المختار',
            color: const Color(0xFF8B5CF6),
          ),
          const SizedBox(height: 20),

          // ملخص الحصة
          Text('ماذا درسنا اليوم', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.recapController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'اكتب ملخصاً لما تم تناوله في الحصة اليوم...',
            ),
          ),
          const SizedBox(height: 16),

          // مستوى الأداء العام
          Text('مستوى أداء الفصل', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              children: ['excellent', 'good', 'average', 'poor'].map((p) {
                final isSelected = controller.selectedPerformance.value == p;
                final color = controller.performanceColor(p);
                return GestureDetector(
                  onTap: () => controller.selectedPerformance.value = p,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                      ),
                    ),
                    child: Text(
                      controller.performanceLabel(p),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // مستويات التقييم
          _buildLevelSlider(
            label: 'مستوى المشاركة',
            icon: Icons.record_voice_over_outlined,
            color: const Color(0xFF3B82F6),
            value: controller.participationLevel,
          ),
          const SizedBox(height: 16),
          _buildLevelSlider(
            label: 'مستوى السلوك',
            icon: Icons.sentiment_satisfied_outlined,
            color: const Color(0xFF22C55E),
            value: controller.behaviorLevel,
          ),
          const SizedBox(height: 16),
          _buildLevelSlider(
            label: 'مستوى التركيز',
            icon: Icons.psychology_outlined,
            color: const Color(0xFF8B5CF6),
            value: controller.focusLevel,
          ),
          const SizedBox(height: 16),

          // أبرز اليوم (اختياري)
          Text('أبرز اليوم (اختياري)', style: AppTextStyles.labelBold),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.highlightController,
            decoration: const InputDecoration(
              hintText: 'مثال: تميّز الطلاب في حل المسائل التطبيقية...',
              prefixIcon: Icon(Icons.star_outline, color: Color(0xFFF59E0B)),
            ),
          ),
          const SizedBox(height: 32),

          // زر الإرسال
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: controller.isSavingSummary.value
                    ? null
                    : controller.saveDailySummary,
                icon: controller.isSavingSummary.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(
                  controller.isSavingSummary.value
                      ? 'جارٍ الإرسال...'
                      : 'إرسال الخلاصة للفصل',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLevelSlider({
    required String label,
    required IconData icon,
    required Color color,
    required RxInt value,
  }) {
    // labels وصفية لكل درجة
    final levelLabels = ['ضعيف', 'مقبول', 'جيد', 'جيد جداً', 'ممتاز'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── العنوان ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الدرجة الحالية + label
              Obx(() {
                final v = value.value;
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: v > 0
                            ? color.withOpacity(0.12)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: v > 0
                              ? color.withOpacity(0.3)
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        v > 0 ? levelLabels[v - 1] : 'غير محدد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: v > 0 ? color : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // اسم المستوى + أيقونة
              Row(
                children: [
                  Text(label, style: AppTextStyles.labelBold),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── أزرار التقييم 1-5 ──────────────────────────────────
          Obx(() {
            final current = value.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                final level = 5 - i; // ← عكس الترتيب: 5 يسار، 1 يمين
                final isSelected = level <= current;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => value.value = level,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? color : color.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$level',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : color.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  // ── Info Banner ──────────────────────────────────────────────────────────
  Widget _buildInfoBanner({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Priority Color ───────────────────────────────────────────────────────
  Color _priorityColor(int level) {
    if (level <= 2) return Colors.green;
    if (level == 3) return Colors.orange;
    return Colors.red;
  }
}
