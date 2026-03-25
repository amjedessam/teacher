import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../routes/app_routes.dart';
import '../../data/models/student_model.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return ShimmerWidgets.dashboardShimmer();
        }
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // ── Header ───────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader()),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── التقارير اليومية ─────────────────
                      AnimatedWidgets.fadeIn(
                        delay: const Duration(milliseconds: 350),
                        child: _buildDailyReportBanner(),
                      ),
                      const SizedBox(height: 24),
                      // ── آخر الاختبارات ───────────────────
                      AnimatedWidgets.fadeIn(
                        delay: const Duration(milliseconds: 300),
                        child: _buildRecentExams(),
                      ),
                      const SizedBox(height: 24),

                      // ── تنبيهات الأداء ───────────────────
                      AnimatedWidgets.slideIn(
                        direction: SlideDirection.bottom,
                        delay: const Duration(milliseconds: 400),
                        child: _buildLowPerformers(),
                      ),
                      const SizedBox(height: 24),

                      // ── إجراءات سريعة ────────────────────
                      AnimatedWidgets.scaleIn(
                        delay: const Duration(milliseconds: 500),
                        child: _buildQuickActions(),
                      ),
                      const SizedBox(height: 24),

                      // ── آخر الإشعارات ────────────────────
                      AnimatedWidgets.fadeIn(
                        delay: const Duration(milliseconds: 600),
                        child: _buildRecentNotifications(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── الهيدر المُحسَّن ──────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -30,
              left: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -20,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Greeting
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً أستاذ 👋',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedWidgets.slideIn(
                            direction: SlideDirection.left,
                            duration: const Duration(milliseconds: 700),
                            child: Obx(
                              () => Text(
                                controller.teacher.value?.name ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Date badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _todayFormatted(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stats row inside header
                  Obx(
                    () => Row(
                      children: [
                        _buildHeaderStat(
                          icon: Icons.people_alt_rounded,
                          value: '${controller.totalStudents.value}',
                          label: 'طالب',
                        ),
                        _buildHeaderDivider(),
                        _buildHeaderStat(
                          icon: Icons.class_rounded,
                          value: '${controller.totalClasses.value}',
                          label: 'صف',
                        ),
                        _buildHeaderDivider(),
                        _buildHeaderStat(
                          icon: Icons.quiz_rounded,
                          value: '${controller.totalExams.value}',
                          label: 'اختبار',
                        ),
                        _buildHeaderDivider(),
                        _buildHeaderStat(
                          icon: Icons.trending_up_rounded,
                          value:
                              '${controller.avgScore.value.toStringAsFixed(0)}%',
                          label: 'المعدل',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.85), size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.2),
    );
  }

  String _todayFormatted() {
    final now = DateTime.now();
    const days = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return '${days[now.weekday - 1]}، ${now.day}/${now.month}';
  }

  // ── آخر الاختبارات المرسلة ───────────────────────────────
  Widget _buildRecentExams() {
    return Obx(() {
      if (controller.recentExams.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('آخر الاختبارات', style: AppTextStyles.h4),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.classes),
                child: Text(
                  'عرض الكل',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...controller.recentExams.map((exam) => _buildRecentExamCard(exam)),
        ],
      );
    });
  }

  Widget _buildRecentExamCard(RecentExam exam) {
    final scoreColor = exam.avgScore == null
        ? AppColors.textSecondary
        : exam.avgScore! >= 70
        ? AppColors.success
        : exam.avgScore! >= 50
        ? AppColors.warning
        : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: AppColors.primary,
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
                  exam.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  exam.subjectName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                // شريط الإكمال
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: exam.completionRate / 100,
                          minHeight: 5,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${exam.totalCompleted}/${exam.totalAssigned}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // متوسط الدرجة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                exam.avgScore != null
                    ? '${exam.avgScore!.toStringAsFixed(0)}%'
                    : '—',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
              Text(
                'متوسط',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── بانر التقارير اليومية ──────────────────────────────────
  Widget _buildDailyReportBanner() {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.dailyReport),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF3B82F6)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D9488).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقارير اليومية',
                    style: AppTextStyles.h4.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'اكتب تقرير اليوم لطلابك الآن',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // ── تنبيهات الأداء المنخفض ──────────────────────────────
  Widget _buildLowPerformers() {
    return Obx(() {
      if (controller.lowPerformers.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('تنبيهات الأداء', style: AppTextStyles.h4),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${controller.lowPerformers.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'طلاب تحت 50% في آخر 30 يوماً',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: controller.lowPerformers.asMap().entries.map((entry) {
                final isLast = entry.key == controller.lowPerformers.length - 1;
                return _buildLowPerformerItem(entry.value, isLast);
              }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLowPerformerItem(LowPerformer student, bool isLast) {
    final color = student.percentage < 30 ? AppColors.error : AppColors.warning;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            // بناء StudentModel للانتقال لتفاصيل الطالب
            final studentModel = StudentModel(
              id: student.studentId.toString(),
              name: student.studentName,
              email: '',
              studentCode: '',
              classId: '${student.sectionId}_${student.className}',
              className: student.className,
              profileImage: '',
              averageScore: student.percentage,
              totalQuizzes: 0,
              completedQuizzes: 0,
              masteryLevel: 'Needs Improvement',
              subjectPerformance: [],
              lastActive: DateTime.now(),
            );
            Get.toNamed(
              AppRoutes.studentDetail,
              arguments: {'student': studentModel},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${student.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
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
                        student.studentName,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${student.examTitle} • ${student.subjectName}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        student.className,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: color),
              ],
            ),
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 64, color: AppColors.border),
      ],
    );
  }

  // ── إجراءات سريعة ────────────────────────────────────────
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إجراءات سريعة', style: AppTextStyles.h4),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'إضافة سؤال',
                icon: Icons.add_circle_outline,
                color: AppColors.primary,
                onTap: () => Get.toNamed(AppRoutes.addQuestion),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                title: 'بناء اختبار',
                icon: Icons.auto_awesome,
                color: AppColors.secondary,
                onTap: () => Get.toNamed(AppRoutes.quizBuilder),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'التقارير',
                icon: Icons.analytics_outlined,
                color: AppColors.warning,
                onTap: () => Get.toNamed(AppRoutes.reports),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                title: 'جودة الأسئلة',
                icon: Icons.verified_outlined,
                color: AppColors.info,
                onTap: () => Get.toNamed(AppRoutes.questionQuality),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedWidgets.bounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  // ── آخر الإشعارات ────────────────────────────────────────
  Widget _buildRecentNotifications() {
    final recent = controller.notifications.take(3).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('آخر الإشعارات', style: AppTextStyles.h4),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.notifications),
              child: Text(
                'عرض الكل',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              delay: const Duration(milliseconds: 100),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: recent.map((n) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: n.isRead
                          ? AppColors.border
                          : AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(n.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getNotificationIcon(n.type),
                          color: _getNotificationColor(n.type),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              n.message,
                              style: AppTextStyles.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!n.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'quiz_completed':
        return Icons.check_circle_outline;
      case 'low_performance':
        return Icons.warning_amber_outlined;
      case 'new_student':
        return Icons.person_add_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'quiz_completed':
        return AppColors.success;
      case 'low_performance':
        return AppColors.warning;
      case 'new_student':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}
