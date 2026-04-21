import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'class_detail_controller.dart';

class ClassDetailView extends GetView<ClassDetailController> {
  const ClassDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final classItem = controller.classItem.value;
      if (classItem == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('لم يتم العثور على الفصل')),
        );
      }

      // تحويل لون DB لأقرب لون متناسق من الـ Palette الجديد
      final color = AppColors.getClassColor(classItem.color);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              classItem.icon,
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          classItem.name,
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            classItem.grade,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => _buildStatCard(
                              label: 'الطلاب',
                              value: '${controller.students.length}',
                              icon: Icons.people_alt_outlined,
                              color: AppColors.primary, // Teal
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 'الاختبارات',
                            value: '${controller.classExams.length}',
                            icon: Icons.quiz_outlined,
                            color: AppColors.secondary, // Blue
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() {
                            final scores = controller.classExams
                                .where((e) => e.averageScore != null)
                                .map((e) => e.averageScore!)
                                .toList();
                            final avg = scores.isEmpty
                                ? 0.0
                                : scores.reduce((a, b) => a + b) /
                                      scores.length;
                            return _buildStatCard(
                              label: 'المعدل',
                              value: scores.isEmpty
                                  ? '—'
                                  : '${avg.toStringAsFixed(1)}%',
                              icon: Icons.stars_outlined,
                              color: AppColors.accent, // Orange
                            );
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        const SizedBox(width: 0),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.openAttendance,
                            icon: const Icon(
                              Icons.event_note_outlined,
                              size: 18,
                            ),
                            label: const Text('تسجيل الحضور'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: AppTextStyles.buttonSmall,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.createQuizForClass,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                            ),
                            label: const Text('إنشاء اختبار'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: AppTextStyles.buttonSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.goToGapsAnalysis();
                          // Get.toNamed(
                          //   AppRoutes.curriculumGaps,
                          //   arguments: classItem,
                          // );
                        },
                        icon: const Icon(Icons.menu_book_outlined, size: 18),
                        label: const Text('الفجوات المنهجية'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          backgroundColor: AppColors.secondarySurface,
                          foregroundColor: AppColors.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.secondary.withOpacity(0.4),
                            ),
                          ),
                          textStyle: AppTextStyles.buttonSmall.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildTabs(),

                    const SizedBox(height: 16),

                    _buildTabContent(classItem, color),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Obx(
      () => Container(
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
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _buildTab(
                title: 'الطلاب',
                icon: Icons.people_alt_outlined,
                index: 0,
              ),
            ),
            Expanded(
              child: _buildTab(
                title: 'الاختبارات',
                icon: Icons.quiz_outlined,
                index: 1,
              ),
            ),
            // Expanded(
            //   child: _buildTab(
            //     title: 'الأداء',
            //     icon: Icons.trending_up_rounded,
            //     index: 2,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final isSelected = controller.selectedTabIndex.value == index;
    return InkWell(
      onTap: () => controller.changeTab(index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.primary.withOpacity(0.3))
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(classItem, Color color) {
    return Obx(() {
      switch (controller.selectedTabIndex.value) {
        case 0:
          return _buildStudentsTab();
        case 1:
          return _buildQuizzesTab(
            classItem,
            color,
          ); // ✅ تم التغيير من _buildStatisticsTab
        case 2:
        // return _buildPerformanceTab(classItem, color);
        default:
          return const SizedBox();
      }
    });
  }

  Widget _buildStudentsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.students.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قائمة الطلاب (${controller.students.length})',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),
          ...controller.students
              .map(
                (student) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowCard,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => controller.viewStudentDetail(student),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student.className,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                student.averageScore > 0
                                    ? '${student.averageScore.toStringAsFixed(1)}%'
                                    : '—',
                                style: AppTextStyles.h4.copyWith(
                                  color: student.averageScore > 0
                                      ? _getScoreColor(student.averageScore)
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getMasteryColor(
                                    student.masteryLevel,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getMasteryLabel(student.masteryLevel),
                                  style: AppTextStyles.caption.copyWith(
                                    color: _getMasteryColor(
                                      student.masteryLevel,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      );
    });
  }

  // ✅ قسم الاختبارات الجديد (فارغ حالياً)
  // Widget _buildQuizzesTab(classItem, Color color) {
  //   return Center(
  //     child: Padding(
  //       padding: const EdgeInsets.all(40),
  //       child: Column(
  //         children: [
  //           Icon(
  //             Icons.quiz_outlined,
  //             size: 80,
  //             color: AppColors.textSecondary.withOpacity(0.3),
  //           ),
  //           const SizedBox(height: 24),
  //           Text(
  //             'لا توجد اختبارات بعد',
  //             style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             'قم بإنشاء اختبار جديد للفصل',
  //             style: AppTextStyles.bodyMedium.copyWith(
  //               color: AppColors.textSecondary.withOpacity(0.7),
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 24),
  //           ElevatedButton.icon(
  //             onPressed: controller.createQuizForClass,
  //             icon: const Icon(Icons.add),
  //             label: const Text('إنشاء اختبار'),
  //             style: ElevatedButton.styleFrom(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 32,
  //                 vertical: 16,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildQuizzesTab(classItem, Color color) {
    return Obx(() {
      if (controller.isLoadingExams.value) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.classExams.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 80,
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
                const SizedBox(height: 24),
                Text(
                  'لا توجد اختبارات بعد',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'قم بإنشاء اختبار جديد للفصل',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.createQuizForClass,
                  icon: const Icon(Icons.add),
                  label: const Text('إنشاء اختبار'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ملخص سريع ────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: 'إجمالي الاختبارات',
                  value: '${controller.classExams.length}',
                  icon: Icons.quiz_outlined,
                  color: AppColors.secondary, // Blue
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  label: 'متوسط الفصل',
                  value: () {
                    final scores = controller.classExams
                        .where((e) => e.averageScore != null)
                        .map((e) => e.averageScore!)
                        .toList();
                    if (scores.isEmpty) return '—';
                    final avg = scores.reduce((a, b) => a + b) / scores.length;
                    return '${avg.toStringAsFixed(1)}%';
                  }(),
                  icon: Icons.stars_outlined,
                  color: AppColors.accent, // Orange
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'الاختبارات (${controller.classExams.length})',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 16),

          // ── قائمة الاختبارات ─────────────────────────────────────────────
          ...controller.classExams.map((exam) => _buildExamCard(exam, color)),
        ],
      );
    });
  }

  Widget _buildExamCard(exam, Color color) {
    final hasResults = exam.averageScore != null;
    final avgColor = hasResults
        ? (exam.averageScore! >= exam.passingMarks / exam.totalMarks * 100
              ? AppColors.success
              : AppColors.error)
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${exam.createdAt.day}/${exam.createdAt.month}/${exam.createdAt.year}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: avgColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hasResults
                        ? '${exam.averageScore!.toStringAsFixed(1)}%'
                        : 'لا يوجد',
                    style: AppTextStyles.labelBold.copyWith(color: avgColor),
                  ),
                ),
              ],
            ),
          ),

          // ── Stats ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _examStat(
                      Icons.timer_outlined,
                      '${exam.durationMinutes} د',
                      'المدة',
                      AppColors.secondary,
                    ),
                    _vDivider(),
                    _examStat(
                      Icons.star_outline,
                      '${exam.totalMarks}',
                      'الدرجة الكلية',
                      AppColors.accent,
                    ),
                    _vDivider(),
                    _examStat(
                      Icons.people_outline,
                      '${exam.totalAssigned}',
                      'مُرسل لـ',
                      AppColors.primary,
                    ),
                    _vDivider(),
                    _examStat(
                      Icons.check_circle_outline,
                      '${exam.totalCompleted}',
                      'أكمل',
                      AppColors.success,
                    ),
                  ],
                ),

                if (exam.totalAssigned > 0) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('نسبة الإكمال', style: AppTextStyles.bodySmall),
                      Text(
                        '${exam.completionRate.toStringAsFixed(0)}%',
                        style: AppTextStyles.labelBold.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: exam.completionRate / 100,
                      minHeight: 8,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                const Divider(height: 1),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => controller.openExamDetail(exam),
                    icon: const Icon(
                      Icons.analytics_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      'عرض التفاصيل والإحصائيات',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _examStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.labelBold.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _vDivider() {
    return Container(width: 1, height: 40, color: AppColors.border);
  }

  // ✅ قسم الأداء - مع إضافة الإحصائيات المنقولة من القسم السابق
  // Widget _buildPerformanceTab(classItem, Color color) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // ========== الإحصائيات المنقولة ==========
  //       Text('إحصائيات الفصل', style: AppTextStyles.h4),
  //       const SizedBox(height: 16),

  //       // توزيع مستويات الإتقان
  //       Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: AppColors.surface,
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(color: AppColors.border),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.shadowCard,
  //               blurRadius: 8,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('توزيع مستويات الإتقان', style: AppTextStyles.labelBold),
  //             const SizedBox(height: 20),
  //             _buildDistributionBar('متقن', 30, AppColors.success),
  //             _buildDistributionBar('جيد', 40, AppColors.info),
  //             _buildDistributionBar('متوسط', 20, AppColors.warning),
  //             _buildDistributionBar('يحتاج تحسين', 10, AppColors.error),
  //           ],
  //         ),
  //       ),

  //       const SizedBox(height: 16),

  //       // معلومات الاختبارات
  //       Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: AppColors.surface,
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(color: AppColors.border),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.shadowCard,
  //               blurRadius: 8,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             _buildStatRow('إجمالي الاختبارات', '${classItem.totalQuizzes}'),
  //             const Divider(height: 24),
  //             _buildStatRow(
  //               'الاختبارات المكتملة',
  //               '${(classItem.totalQuizzes * 0.9).round()}',
  //             ),
  //             const Divider(height: 24),
  //             _buildStatRow('معدل الإكمال', '90%'),
  //           ],
  //         ),
  //       ),

  //       // ========== أداء المواضيع ==========
  //       const SizedBox(height: 24),
  //       Text('أداء المواضيع', style: AppTextStyles.h4),
  //       const SizedBox(height: 16),

  //       _buildPerformanceCard('الجبر', 85.5, 'up', AppColors.success),
  //       _buildPerformanceCard('الهندسة', 78.3, 'down', AppColors.warning),
  //       _buildPerformanceCard('حساب المثلثات', 82.1, 'up', AppColors.info),
  //       _buildPerformanceCard('الإحصاء', 76.8, 'stable', AppColors.warning),
  //     ],
  //   );
  // }

  Widget _buildDistributionBar(String label, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text(
                '$percentage%',
                style: AppTextStyles.labelBold.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildPerformanceCard(
    String subject,
    double score,
    String trend,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    _getTrendIcon(trend),
                    color: _getTrendColor(trend),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${score.toStringAsFixed(1)}%',
                    style: AppTextStyles.labelBold.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return AppColors.success;
      case 'down':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getMasteryLabel(String level) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('👥', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text('لا يوجد طلاب', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              'لم يتم إضافة طلاب لهذا الفصل بعد',
              style: AppTextStyles.bodySmall.copyWith(
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
