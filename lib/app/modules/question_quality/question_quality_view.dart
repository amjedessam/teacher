import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/question_model.dart';
import 'question_quality_controller.dart';

class QuestionQualityView extends GetView<QuestionQualityController> {
  const QuestionQualityView({super.key});

  // ── Semantic Colors متناسقة مع الـ Palette ─────────────
  static const _cExcellent = Color(0xFF16A34A); // success
  static const _cGood = Color(0xFF0D9488); // primary teal
  static const _cFair = Color(0xFFF59E0B); // warning
  static const _cReview = Color(0xFFDC2626); // error
  static const _cUnused = Color(0xFF8796B0); // tertiary

  Color _qualityColor(String q) {
    switch (q) {
      case 'ممتاز':
        return _cExcellent;
      case 'جيد':
        return _cGood;
      case 'مقبول':
        return _cFair;
      case 'يحتاج مراجعة':
        return _cReview;
      case 'لم يُستخدم بعد':
        return _cUnused;
      default:
        return AppColors.textTertiary;
    }
  }

  Color _diffColor(String d) {
    switch (d) {
      case 'easy':
        return _cExcellent;
      case 'medium':
        return _cFair;
      case 'hard':
        return _cReview;
      default:
        return AppColors.textTertiary;
    }
  }

  String _diffLabel(String d) {
    switch (d) {
      case 'easy':
        return 'سهل';
      case 'medium':
        return 'متوسط';
      case 'hard':
        return 'صعب';
      default:
        return d;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'جودة الأسئلة',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: controller.loadQuestions,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.loadQuestions,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildStatsSection()),
              SliverToBoxAdapter(child: _buildFiltersSection()),
              SliverToBoxAdapter(child: _buildResultCounter()),
              Obx(
                () => controller.filteredQuestions.isEmpty
                    ? SliverFillRemaining(child: _buildEmptyState())
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => _buildQuestionCard(
                              controller.filteredQuestions[i],
                            ),
                            childCount: controller.filteredQuestions.length,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ════════════════════════════════════════════════════════
  //  STATS SECTION — خلفية فاتحة + بطاقات Glass واضحة
  // ════════════════════════════════════════════════════════
  Widget _buildStatsSection() {
    return Obx(() {
      final total = controller.totalQuestions;
      return Container(
        color: AppColors.surface,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── العنوان ──────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ملخص الجودة', style: AppTextStyles.h4),
                    Text(
                      '$total سؤال في البنك',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── البطاقات 2×3 ─────────────────────────────
            Row(
              children: [
                _buildStatTile(
                  'الإجمالي',
                  '$total',
                  Icons.quiz_outlined,
                  AppColors.primary,
                  true,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'ممتاز',
                  '${controller.excellentCount}',
                  Icons.emoji_events_outlined,
                  _cExcellent,
                  false,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'جيد',
                  '${controller.goodCount}',
                  Icons.thumb_up_alt_outlined,
                  _cGood,
                  false,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatTile(
                  'مقبول',
                  '${controller.fairCount}',
                  Icons.remove_circle_outline,
                  _cFair,
                  false,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'يحتاج مراجعة',
                  '${controller.needsReviewCount}',
                  Icons.warning_amber_outlined,
                  _cReview,
                  false,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'لم يُستخدم',
                  '${controller.unusedCount}',
                  Icons.hourglass_empty_rounded,
                  _cUnused,
                  false,
                ),
              ],
            ),

            // ── شريط التوزيع ─────────────────────────────
            if (total > 0) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'توزيع الجودة',
                    style: AppTextStyles.captionBold.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // Legend
                  Row(
                    children: [
                      _buildLegendDot('ممتاز', _cExcellent),
                      _buildLegendDot('جيد', _cGood),
                      _buildLegendDot('مقبول', _cFair),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 12,
                  child: Row(
                    children: [
                      _buildBar(controller.excellentCount, total, _cExcellent),
                      _buildBar(controller.goodCount, total, _cGood),
                      _buildBar(controller.fairCount, total, _cFair),
                      _buildBar(controller.needsReviewCount, total, _cReview),
                      _buildBar(controller.unusedCount, total, _cUnused),
                    ].where((w) => w != null).cast<Widget>().toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildStatTile(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isPrimary,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary.withOpacity(0.08)
              : color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPrimary
                ? AppColors.primary.withOpacity(0.3)
                : color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.h2.copyWith(
                color: color,
                fontSize: 22,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildBar(int count, int total, Color color) {
    if (count == 0) return null;
    return Flexible(
      flex: count,
      child: Container(color: color),
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  FILTERS SECTION
  // ════════════════════════════════════════════════════════
  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text('تصفية', style: AppTextStyles.labelBold),
                const Spacer(),
                Obx(() {
                  final active =
                      controller.selectedSubjectId.value != null ||
                      controller.selectedQuality.value != null ||
                      controller.selectedDifficulty.value != null;
                  if (!active) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: controller.clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 13,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'مسح',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.divider),

          // ── فلتر المادة ───────────────────────────────
          _buildFilterRow(
            label: 'المادة',
            icon: Icons.book_outlined,
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 14, bottom: 2),
                child: Row(
                  children: [
                    _buildPill(
                      'الكل',
                      controller.selectedSubjectId.value == null,
                      () => controller.filterBySubject(null),
                    ),
                    ...controller.availableSubjects.map(
                      (s) => _buildPill(
                        s['name']!,
                        controller.selectedSubjectId.value == s['id'],
                        () => controller.filterBySubject(s['id']),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.divider),

          // ── فلتر الجودة ───────────────────────────────
          _buildFilterRow(
            label: 'الجودة',
            icon: Icons.star_outline_rounded,
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 14, bottom: 2),
                child: Row(
                  children: [
                    _buildPill(
                      'الكل',
                      controller.selectedQuality.value == null,
                      () => controller.filterByQuality(null),
                    ),
                    ...[
                      'ممتاز',
                      'جيد',
                      'مقبول',
                      'يحتاج مراجعة',
                      'لم يُستخدم بعد',
                    ].map(
                      (q) => _buildPill(
                        q,
                        controller.selectedQuality.value == q,
                        () => controller.filterByQuality(q),
                        color: _qualityColor(q),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.divider),

          // ── فلتر الصعوبة ──────────────────────────────
          _buildFilterRow(
            label: 'الصعوبة',
            icon: Icons.bar_chart_rounded,
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(right: 14, bottom: 2),
                child: Row(
                  children: [
                    _buildPill(
                      'الكل',
                      controller.selectedDifficulty.value == null,
                      () => controller.filterByDifficulty(null),
                    ),
                    const SizedBox(width: 6),
                    _buildPill(
                      'سهل',
                      controller.selectedDifficulty.value == 'easy',
                      () => controller.filterByDifficulty('easy'),
                      color: _cExcellent,
                    ),
                    const SizedBox(width: 6),
                    _buildPill(
                      'متوسط',
                      controller.selectedDifficulty.value == 'medium',
                      () => controller.filterByDifficulty('medium'),
                      color: _cFair,
                    ),
                    const SizedBox(width: 6),
                    _buildPill(
                      'صعب',
                      controller.selectedDifficulty.value == 'hard',
                      () => controller.filterByDifficulty('hard'),
                      color: _cReview,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // العنوان الجانبي
          SizedBox(
            width: 72,
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                children: [
                  Icon(icon, size: 14, color: AppColors.textTertiary),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 36, color: AppColors.divider),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildPill(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    Color? color,
  }) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? c : c.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? c : c.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : c,
          ),
        ),
      ),
    );
  }

  // ── عداد النتائج ─────────────────────────────────────────
  Widget _buildResultCounter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Obx(
        () => Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryBorder),
              ),
              child: Text(
                '${controller.filteredQuestions.length} سؤال',
                style: AppTextStyles.captionBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  QUESTION CARD
  // ════════════════════════════════════════════════════════
  Widget _buildQuestionCard(QuestionModel question) {
    final qColor = _qualityColor(question.quality);
    final dColor = _diffColor(question.difficulty);
    final total = question.timesCorrect + question.timesIncorrect;
    final rate = total > 0 ? question.timesCorrect / total * 100 : null;
    final rColor = rate == null
        ? AppColors.textTertiary
        : rate >= 70
        ? _cExcellent
        : _cFair;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── شريط جانبي لون الجودة ─────────────────
              Container(width: 5, color: qColor),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── الصف الأول: نص + badge ────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              question.questionText,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.45,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Badge الجودة
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: qColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: qColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              question.quality,
                              style: AppTextStyles.caption.copyWith(
                                color: qColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ── المادة + المنشئ + الصعوبة ────────
                      Row(
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 13,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            question.subject,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.person_outline_rounded,
                            size: 13,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              question.createdByTeacherName ?? 'الأدمن',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: dColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: dColor.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              _diffLabel(question.difficulty),
                              style: AppTextStyles.caption.copyWith(
                                color: dColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: AppColors.divider),
                      const SizedBox(height: 10),

                      // ── إحصائيات الاستخدام ─────────────
                      Row(
                        children: [
                          _buildStat(
                            Icons.repeat_rounded,
                            '${question.timesUsed}',
                            'استُخدم',
                            AppColors.primary,
                          ),
                          _buildVDiv(),
                          _buildStat(
                            Icons.check_circle_outline_rounded,
                            '${question.timesCorrect}',
                            'صح',
                            _cExcellent,
                          ),
                          _buildVDiv(),
                          _buildStat(
                            Icons.cancel_outlined,
                            '${question.timesIncorrect}',
                            'خطأ',
                            _cReview,
                          ),
                          _buildVDiv(),
                          _buildStat(
                            Icons.percent_rounded,
                            rate != null ? '${rate.toStringAsFixed(0)}%' : '—',
                            'النجاح',
                            rColor,
                          ),
                        ],
                      ),

                      // ── Progress bar ──────────────────
                      if (rate != null) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: rate / 100,
                            minHeight: 5,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(rColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.labelBold.copyWith(color: color, fontSize: 14),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVDiv() =>
      Container(width: 1, height: 36, color: AppColors.divider);

  // ── Empty State ───────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.quiz_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('لا توجد أسئلة', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'لا توجد أسئلة تطابق الفلاتر المحددة',
              style: AppTextStyles.bodyMedium.copyWith(
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
