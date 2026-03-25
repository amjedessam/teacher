import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher/app/modules/classes_detail/class_detail_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ExamDetailView extends StatefulWidget {
  const ExamDetailView({Key? key}) : super(key: key);

  @override
  State<ExamDetailView> createState() => _ExamDetailViewState();
}

class _ExamDetailViewState extends State<ExamDetailView> {
  late final ClassExamStat exam;
  late final int sectionId;
  ExamDetailStats? stats;
  bool isLoading = true;

  SupabaseClient get _client => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    exam = args['exam'] as ClassExamStat;
    sectionId = args['sectionId'] as int;
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final res = await _client.rpc(
        'get_exam_detail_stats',
        params: {'p_exam_id': exam.examId, 'p_section_id': sectionId},
      );
      if (res != null) {
        setState(() {
          stats = ExamDetailStats.fromJson(Map<String, dynamic>.from(res));
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('_loadStats error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          exam.title,
                          style: AppTextStyles.h3.copyWith(color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${exam.createdAt.day}/${exam.createdAt.month}/${exam.createdAt.year}  •  ${exam.durationMinutes} دقيقة  •  ${exam.totalMarks} درجة',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (stats == null)
            SliverFillRemaining(
              child: Center(
                child: Text('لا توجد بيانات', style: AppTextStyles.bodyMedium),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── إحصائيات رئيسية ──────────────────────
                  _buildMainStats(),
                  const SizedBox(height: 16),

                  // ── ناجح / راسب ───────────────────────────
                  _buildPassFailSection(),
                  const SizedBox(height: 16),

                  // ── الدرجات ───────────────────────────────
                  if (stats!.avgPercentage != null) ...[
                    _buildScoresSection(),
                    const SizedBox(height: 16),
                  ],

                  // ── الأسئلة الأكثر إخفاقاً ────────────────
                  _buildWeakQuestionsSection(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  // ── إحصائيات رئيسية ─────────────────────────────────────
  Widget _buildMainStats() {
    return Row(
      children: [
        _buildStatCard(
          label: 'طالب مُرسل',
          value: '${stats!.totalAssigned}',
          icon: Icons.people_outline,
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          label: 'أكمل الاختبار',
          value: '${stats!.totalCompleted}',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          label: 'نسبة الإكمال',
          value: stats!.totalAssigned == 0
              ? '0%'
              : '${(stats!.totalCompleted / stats!.totalAssigned * 100).toStringAsFixed(0)}%',
          icon: Icons.bar_chart,
          color: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── ناجح / راسب ─────────────────────────────────────────
  Widget _buildPassFailSection() {
    final total = stats!.passed + stats!.failed;
    final passRate = total == 0 ? 0.0 : stats!.passed / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('نتائج الطلاب', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          Row(
            children: [
              // ناجح
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${stats!.passed}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ناجح',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // راسب
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${stats!.failed}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel, color: AppColors.error, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'راسب',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('نسبة النجاح', style: AppTextStyles.bodySmall),
                Text(
                  '${(passRate * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: passRate,
                minHeight: 10,
                backgroundColor: AppColors.error.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── الدرجات ──────────────────────────────────────────────
  Widget _buildScoresSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الدرجات', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildScoreItem(
                label: 'متوسط الدرجة',
                value: '${stats!.avgPercentage?.toStringAsFixed(1)}%',
                color: AppColors.primary,
                icon: Icons.equalizer,
              ),
              _buildVDivider(),
              _buildScoreItem(
                label: 'أعلى درجة',
                value: '${stats!.highestScore?.toStringAsFixed(1)}%',
                color: AppColors.success,
                icon: Icons.arrow_upward,
              ),
              _buildVDivider(),
              _buildScoreItem(
                label: 'أدنى درجة',
                value: '${stats!.lowestScore?.toStringAsFixed(1)}%',
                color: AppColors.error,
                icon: Icons.arrow_downward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVDivider() =>
      Container(width: 1, height: 50, color: AppColors.border);

  // ── الأسئلة الأكثر إخفاقاً ──────────────────────────────
  Widget _buildWeakQuestionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
              Text('الأسئلة الأكثر إخفاقاً', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'الأسئلة التي أخطأ فيها أكثر الطلاب',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          if (stats!.weakQuestions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: AppColors.success,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ممتاز! لا توجد أسئلة تحتاج مراجعة',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...stats!.weakQuestions.asMap().entries.map((entry) {
              final index = entry.key;
              final q = entry.value;
              return _buildWeakQuestionItem(index + 1, q);
            }),
        ],
      ),
    );
  }

  Widget _buildWeakQuestionItem(int rank, WeakQuestion q) {
    final failColor = q.failRate >= 70
        ? AppColors.error
        : q.failRate >= 40
        ? AppColors.warning
        : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: failColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: failColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رقم الترتيب
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: failColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: failColor,
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
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMiniStat(
                      '${q.totalAttempts}',
                      'محاولة',
                      AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildMiniStat(
                      '${q.wrongAttempts}',
                      'أخطأ',
                      AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    _buildMiniStat(
                      '${q.failRate.toStringAsFixed(0)}%',
                      'نسبة الخطأ',
                      failColor,
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

  Widget _buildMiniStat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}
