import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'student_detail_controller.dart';

class StudentDetailView extends GetView<StudentDetailController> {
  const StudentDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final student = controller.student.value;
      if (student == null) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('لم يتم العثور على الطالب')),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                                student.profileImage.isNotEmpty &&
                                    student.profileImage.startsWith('http')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      student.profileImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Text(
                                        '👤',
                                        style: TextStyle(fontSize: 36),
                                      ),
                                    ),
                                  )
                                : Text(
                                    student.profileImage.isNotEmpty
                                        ? student.profileImage
                                        : '👤',
                                    style: const TextStyle(fontSize: 40),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          student.name,
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ' ${student.className}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Obx(() {
                // ── Loading ────────────────────────────────────
                if (controller.isLoadingStats.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // ── Stats Row ──────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'المعدل',
                              value:
                                  '${controller.averageScore.value.toStringAsFixed(1)}%',
                              icon: Icons.star,
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'الاختبارات',
                              value:
                                  '${controller.completedExams.value}/${controller.totalExams.value}',
                              icon: Icons.quiz,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'الحضور',
                              value:
                                  '${controller.attendancePercentage.toStringAsFixed(0)}%',
                              icon: Icons.check_circle_outline,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ✅ ── تفاصيل الحضور (منقول من التاب) ──────────────
                      if (controller.totalDays.value > 0) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'نسبة الحضور الكلية',
                                    style: AppTextStyles.h4,
                                  ),
                                  Text(
                                    '${controller.attendancePercentage.toStringAsFixed(1)}%',
                                    style: AppTextStyles.h3.copyWith(
                                      color:
                                          controller.attendancePercentage >= 75
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: controller.attendancePercentage / 100,
                                  minHeight: 12,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    controller.attendancePercentage >= 75
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildAttendanceDetailItem(
                                    label: 'حاضر',
                                    count: controller.presentDays.value,
                                    total: controller.totalDays.value,
                                    color: AppColors.success,
                                  ),
                                  _buildAttendanceDetailItem(
                                    label: 'غائب',
                                    count: controller.absentDays.value,
                                    total: controller.totalDays.value,
                                    color: AppColors.error,
                                  ),
                                  _buildAttendanceDetailItem(
                                    label: 'متأخر',
                                    count: controller.lateDays.value,
                                    total: controller.totalDays.value,
                                    color: AppColors.warning,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ── Mastery Level ──────────────────────
                      // Container(
                      //   padding: const EdgeInsets.all(20),
                      //   decoration: BoxDecoration(
                      //     color: _getMasteryColor(
                      //       student.masteryLevel,
                      //     ).withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(16),
                      //     border: Border.all(
                      //       color: _getMasteryColor(
                      //         student.masteryLevel,
                      //       ).withOpacity(0.3),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.all(12),
                      //         decoration: BoxDecoration(
                      //           color: _getMasteryColor(
                      //             student.masteryLevel,
                      //           ).withOpacity(0.2),
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //         child: Icon(
                      //           _getMasteryIcon(student.masteryLevel),
                      //           color: _getMasteryColor(student.masteryLevel),
                      //           size: 28,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 16),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'مستوى الإتقان',
                      //               style: AppTextStyles.bodySmall,
                      //             ),
                      //             const SizedBox(height: 4),
                      //             Text(
                      //               _getMasteryLevelLabel(student.masteryLevel),
                      //               style: AppTextStyles.h4.copyWith(
                      //                 color: _getMasteryColor(
                      //                   student.masteryLevel,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 24),

                      // ── Action Buttons Row ──────────────────────
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: controller.isLoadingExams.value
                                    ? null
                                    : controller.sendMessage,
                                icon: controller.isLoadingExams.value
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.quiz_outlined, size: 18),
                                label: const Text('اختبار فردي'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.studentNote,
                                    arguments: {
                                      'student': controller.student.value,
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.note_add_outlined,
                                  size: 18,
                                ),
                                label: const Text('ملاحظة'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildTabs(),
                      const SizedBox(height: 16),
                      _buildTabContent(student),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAttendanceDetailItem({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final pct = total > 0 ? ((count / total) * 100).toStringAsFixed(0) : '0';
    return Column(
      children: [
        Text('$count يوم', style: AppTextStyles.h4.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
        Text('$pct%', style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
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
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color.withOpacity(0.75),
              fontWeight: FontWeight.w500,
            ),
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
                title: 'الأداء',
                icon: Icons.trending_up_rounded,
                index: 0,
              ),
            ),
            Expanded(
              child: _buildTab(
                title: 'الاختبارات',
                icon: Icons.history_rounded,
                index: 1,
              ),
            ),
            // Expanded(
            //   child: _buildTab(
            //     title: 'الحضور',
            //     icon: Icons.calendar_month_outlined,
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

  Widget _buildTabContent(student) {
    return Obx(() {
      switch (controller.selectedTabIndex.value) {
        case 0:
          return _buildPerformanceTab();
        case 1:
          return _buildHistoryTab();
        case 2:
          return _buildAttendanceTab();
        default:
          return const SizedBox();
      }
    });
  }

  // ── Tab 0: Performance ─────────────────────────────────────────
  Widget _buildPerformanceTab() {
    return Obx(() {
      if (controller.isLoadingPerformance.value) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final summary = controller.performanceSummary.value;
      if (summary == null) {
        return _buildEmptyState(
          icon: Icons.trending_up,
          message: 'لا توجد بيانات أداء بعد',
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ملخص الاختبارات الرسمية ────────────────
          _buildSectionTitle(
            Icons.assignment_outlined,
            'الاختبارات الرسمية',
            AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildFormalSummaryCard(summary),
          const SizedBox(height: 16),

          // ── أداء المواد — رسمي ─────────────────────
          // if (summary.formalBySubject.isNotEmpty) ...[
          //   _buildSectionTitle(
          //     Icons.book_outlined,
          //     'أداء المواد (رسمي)',
          //     AppColors.primary,
          //   ),
          //   const SizedBox(height: 12),
          //   ...summary.formalBySubject.map((s) => _buildFormalSubjectCard(s)),
          //   const SizedBox(height: 16),
          // ],

          // ── ملخص التدريب الذاتي ────────────────────
          _buildSectionTitle(
            Icons.self_improvement,
            'التدريب الذاتي',
            AppColors.info,
          ),
          const SizedBox(height: 12),
          _buildPracticeSummaryCard(summary),
          const SizedBox(height: 16),

          // ── أداء المواد — تدريب ────────────────────
          if (summary.practiceBySubject.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...summary.practiceBySubject.map(
              (s) => _buildPracticeSubjectCard(s),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.h4),
      ],
    );
  }

  Widget _buildFormalSummaryCard(summary) {
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
        children: [
          Row(
            children: [
              _buildPerformStat(
                '${summary.formalTotal}',
                'إجمالي',
                AppColors.primary,
                Icons.quiz_outlined,
              ),
              _buildVDiv(),
              _buildPerformStat(
                '${summary.formalPassed}',
                'ناجح',
                AppColors.success,
                Icons.check_circle_outline,
              ),
              _buildVDiv(),
              _buildPerformStat(
                '${summary.formalFailed}',
                'راسب',
                AppColors.error,
                Icons.cancel_outlined,
              ),
              _buildVDiv(),
              _buildPerformStat(
                '${summary.formalAvg.toStringAsFixed(1)}%',
                'المتوسط',
                _getScoreColor(summary.formalAvg),
                Icons.percent,
              ),
            ],
          ),
          if (summary.formalTotal > 0) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniBadge(
                  'أعلى: ${summary.formalHighest.toStringAsFixed(0)}%',
                  AppColors.success,
                ),
                _buildMiniBadge(
                  'أدنى: ${summary.formalLowest.toStringAsFixed(0)}%',
                  AppColors.error,
                ),
                _buildMiniBadge(
                  'نسبة النجاح: ${summary.formalTotal == 0 ? 0 : (summary.formalPassed / summary.formalTotal * 100).toStringAsFixed(0)}%',
                  AppColors.primary,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormalSubjectCard(subject) {
    final scoreColor = _getScoreColor(subject.avgScore);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(right: BorderSide(color: scoreColor, width: 3)),
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
                subject.subjectName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${subject.avgScore.toStringAsFixed(1)}%',
                style: AppTextStyles.labelBold.copyWith(color: scoreColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: subject.avgScore / 100,
              minHeight: 7,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMiniBadge(
                '${subject.totalExams} اختبار',
                AppColors.primary,
              ),
              const SizedBox(width: 8),
              _buildMiniBadge('${subject.passed} ناجح', AppColors.success),
              const SizedBox(width: 8),
              _buildMiniBadge('${subject.failed} راسب', AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSummaryCard(summary) {
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
        children: [
          Row(
            children: [
              _buildPerformStat(
                '${summary.practiceTotal}',
                'تدريبات',
                AppColors.info,
                Icons.model_training,
              ),
              _buildVDiv(),
              _buildPerformStat(
                '${summary.practiceAvg.toStringAsFixed(1)}%',
                'المتوسط',
                _getScoreColor(summary.practiceAvg),
                Icons.percent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSubjectCard(subject) {
    final scoreColor = _getScoreColor(subject.avgScore);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(right: BorderSide(color: AppColors.info, width: 3)),
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
                subject.subjectName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${subject.avgScore.toStringAsFixed(1)}%',
                style: AppTextStyles.labelBold.copyWith(color: scoreColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: subject.avgScore / 100,
              minHeight: 7,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMiniBadge('${subject.totalQuizzes} تدريب', AppColors.info),
              if (subject.lastQuizDate != null) ...[
                const SizedBox(width: 8),
                _buildMiniBadge(
                  'آخر تدريب: ${subject.lastQuizDate!.day}/${subject.lastQuizDate!.month}/${subject.lastQuizDate!.year}',
                  AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformStat(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVDiv() =>
      Container(width: 1, height: 40, color: AppColors.border);

  Widget _buildMiniBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

  // ── استبدل دالة _buildHistoryTab كاملاً بهذا الكود ──────────────────────────

  Widget _buildHistoryTab() {
    return Obx(() {
      if (controller.isLoadingExams.value) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final results = controller.examResults;

      if (results.isEmpty) {
        return _buildEmptyState(
          icon: Icons.history,
          message: 'لا توجد اختبارات مكتملة بعد',
        );
      }

      // تقسيم النتائج حسب النوع
      final classExams = results.where((r) => r.isClassExam).toList();
      final individualExams = results.where((r) => !r.isClassExam).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ملخص سريع ──────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  label: 'إجمالي الاختبارات',
                  value: '${results.length}',
                  color: AppColors.primary,
                  icon: Icons.quiz,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniStat(
                  label: 'متوسط الدرجات',
                  value: results.isNotEmpty
                      ? '${(results.map((r) => r.percentage).reduce((a, b) => a + b) / results.length).toStringAsFixed(1)}%'
                      : '0%',
                  color: AppColors.warning,
                  icon: Icons.star,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── اختبارات الفصل ─────────────────────────────────────────────────
          if (classExams.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.people,
              title: 'اختبارات الفصل',
              count: classExams.length,
              color: AppColors.info,
            ),
            const SizedBox(height: 12),
            ...classExams.map((r) => _buildExamResultCard(r)),
            const SizedBox(height: 24),
          ],

          // ── اختبارات فردية ─────────────────────────────────────────────────
          if (individualExams.isNotEmpty) ...[
            _buildSectionHeader(
              icon: Icons.person,
              title: 'اختبارات فردية',
              count: individualExams.length,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            ...individualExams.map((r) => _buildExamResultCard(r)),
          ],
        ],
      );
    });
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.h4),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamResultCard(StudentExamResult result) {
    final scoreColor = _getScoreColor(result.percentage);
    final isClass = result.isClassExam;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isClass
              ? AppColors.secondary.withOpacity(0.25)
              : AppColors.primary.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // أيقونة النوع
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isClass
                        ? AppColors.info.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isClass ? Icons.people : Icons.person,
                    color: isClass ? AppColors.info : AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // العنوان والمادة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.subjectName,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // الدرجة
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${result.percentage.toStringAsFixed(1)}%',
                      style: AppTextStyles.h3.copyWith(color: scoreColor),
                    ),
                    Text(
                      '${result.obtainedMarks.toStringAsFixed(0)}/${result.totalMarks.toStringAsFixed(0)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // شريط الدرجة
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: result.percentage / 100,
                minHeight: 7,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              ),
            ),

            const SizedBox(height: 10),

            // Footer: نوع الاختبار + التاريخ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isClass
                        ? AppColors.info.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isClass ? '👥 اختبار الفصل' : '👤 اختبار فردي',
                    style: AppTextStyles.caption.copyWith(
                      color: isClass ? AppColors.info : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (result.submittedAt != null)
                  Text(
                    '${result.submittedAt!.day}/${result.submittedAt!.month}/${result.submittedAt!.year}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.h4.copyWith(color: color)),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'تفاصيل مستوى الطالب',
              style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              'هذا القسم قيد التطوير',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  String _getMasteryLevelLabel(String level) {
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

  IconData _getMasteryIcon(String level) {
    switch (level) {
      case 'Mastered':
        return Icons.emoji_events;
      case 'Proficient':
        return Icons.thumb_up;
      case 'Developing':
        return Icons.trending_up;
      case 'Needs Improvement':
        return Icons.priority_high;
      default:
        return Icons.help_outline;
    }
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

  Color _getScoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }
}
