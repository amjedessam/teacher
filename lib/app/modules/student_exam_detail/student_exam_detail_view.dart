import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ══════════════════════════════════════════════════════════════
// Models
// ══════════════════════════════════════════════════════════════

class StudentAnswerDetail {
  final int questionId;
  final String questionText;
  final String questionType;
  final Map<String, String> questionOptions;
  final String correctAnswer;
  final String selectedAnswer;
  final bool isCorrect;
  final int marks;

  StudentAnswerDetail({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.questionOptions,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.marks,
  });

  factory StudentAnswerDetail.fromJson(Map<String, dynamic> json) {
    final opts = json['question_options'];
    final Map<String, String> options = {};
    if (opts is Map) {
      opts.forEach((k, v) => options[k.toString()] = v.toString());
    }
    return StudentAnswerDetail(
      questionId: (json['question_id'] as num).toInt(),
      questionText: json['question_text']?.toString() ?? '',
      questionType: json['question_type']?.toString() ?? '',
      questionOptions: options,
      correctAnswer: json['correct_answer']?.toString() ?? '',
      selectedAnswer: json['selected_answer']?.toString() ?? '',
      isCorrect: json['is_correct'] == true,
      marks: (json['marks'] as num?)?.toInt() ?? 1,
    );
  }

  String get correctAnswerText =>
      questionOptions[correctAnswer] ?? correctAnswer;
  String get selectedAnswerText =>
      questionOptions[selectedAnswer] ?? selectedAnswer;
}

class StudentExamDetailData {
  final int examId;
  final String title;
  final String subjectName;
  final double totalMarks;
  final double passingMarks;
  final int durationMinutes;
  final double obtainedMarks;
  final double percentage;
  final String status;
  final DateTime? submittedAt;
  final String assignmentType;
  final List<StudentAnswerDetail> answers;

  StudentExamDetailData({
    required this.examId,
    required this.title,
    required this.subjectName,
    required this.totalMarks,
    required this.passingMarks,
    required this.durationMinutes,
    required this.obtainedMarks,
    required this.percentage,
    required this.status,
    this.submittedAt,
    required this.assignmentType,
    required this.answers,
  });

  bool get isPassed => percentage >= (passingMarks / totalMarks * 100);
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get wrongCount => answers.where((a) => !a.isCorrect).length;

  factory StudentExamDetailData.fromJson(Map<String, dynamic> json) {
    final answersList = json['answers'];
    List<StudentAnswerDetail> answers = [];
    if (answersList is List) {
      answers = answersList
          .map(
            (e) => StudentAnswerDetail.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }
    return StudentExamDetailData(
      examId: (json['exam_id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      subjectName: json['subject_name']?.toString() ?? '',
      totalMarks: (json['total_marks'] as num?)?.toDouble() ?? 0,
      passingMarks: (json['passing_marks'] as num?)?.toDouble() ?? 0,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 30,
      obtainedMarks: (json['obtained_marks'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString())
          : null,
      assignmentType: json['assignment_type']?.toString() ?? 'individual',
      answers: answers,
    );
  }
}

// ══════════════════════════════════════════════════════════════
// View
// ══════════════════════════════════════════════════════════════

class StudentExamDetailView extends StatefulWidget {
  const StudentExamDetailView({Key? key}) : super(key: key);

  @override
  State<StudentExamDetailView> createState() => _StudentExamDetailViewState();
}

class _StudentExamDetailViewState extends State<StudentExamDetailView> {
  late final int studentId;
  late final int examId;
  late final String studentName;

  StudentExamDetailData? data;
  bool isLoading = true;

  SupabaseClient get _client => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    studentId = args['studentId'] as int;
    examId = args['examId'] as int;
    studentName = args['studentName']?.toString() ?? '';
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await _client.rpc(
        'get_student_exam_detail',
        params: {'p_student_id': studentId, 'p_exam_id': examId},
      );
      if (res != null) {
        setState(() {
          data = StudentExamDetailData.fromJson(Map<String, dynamic>.from(res));
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('_load error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (data == null)
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
                  _buildResultSummary(),
                  const SizedBox(height: 16),
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  _buildAnswersSection(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────
  SliverAppBar _buildAppBar() {
    final isPassed = data?.isPassed ?? false;
    final headerColor = data == null
        ? AppColors.primary
        : isPassed
        ? AppColors.success
        : AppColors.error;

    return SliverAppBar(
      expandedHeight: 155,
      pinned: true,
      backgroundColor: headerColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [headerColor, headerColor.withOpacity(0.75)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    data?.title ?? '',
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        studentName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: Colors.white38)),
                      const SizedBox(width: 8),
                      Text(
                        data?.subjectName ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: Colors.white38)),
                      const SizedBox(width: 8),
                      Text(
                        data?.assignmentType == 'individual'
                            ? '👤 فردي'
                            : '👥 فصل',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── ملخص النتيجة ────────────────────────────────────────
  Widget _buildResultSummary() {
    final isPassed = data!.isPassed;
    final color = isPassed ? AppColors.success : AppColors.error;

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
      child: Row(
        children: [
          // دائرة النتيجة
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${data!.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  isPassed ? 'ناجح' : 'راسب',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // تفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  Icons.star_outline,
                  'الدرجة',
                  '${data!.obtainedMarks.toStringAsFixed(0)} / ${data!.totalMarks.toStringAsFixed(0)}',
                  AppColors.warning,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.check_circle_outline,
                  'درجة النجاح',
                  '${data!.passingMarks.toStringAsFixed(0)} درجة',
                  AppColors.success,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.access_time,
                  'تاريخ التسليم',
                  data!.submittedAt != null
                      ? '${data!.submittedAt!.day}/${data!.submittedAt!.month}/${data!.submittedAt!.year}'
                      : 'لم يُسلّم',
                  AppColors.info,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ── إحصائيات الإجابات ───────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          label: 'إجمالي الأسئلة',
          value: '${data!.answers.length}',
          icon: Icons.quiz_outlined,
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          label: 'إجابات صحيحة',
          value: '${data!.correctCount}',
          icon: Icons.check_circle_outline,
          color: AppColors.success,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          label: 'إجابات خاطئة',
          value: '${data!.wrongCount}',
          icon: Icons.cancel_outlined,
          color: AppColors.error,
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
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

  // ── تفاصيل الإجابات ─────────────────────────────────────
  Widget _buildAnswersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list_alt_outlined, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('تفاصيل الإجابات', style: AppTextStyles.h4),
          ],
        ),
        const SizedBox(height: 12),
        ...data!.answers.asMap().entries.map(
          (e) => _buildAnswerCard(e.key + 1, e.value),
        ),
      ],
    );
  }

  Widget _buildAnswerCard(int index, StudentAnswerDetail answer) {
    final color = answer.isCorrect ? AppColors.success : AppColors.error;
    final bgColor = answer.isCorrect
        ? AppColors.success.withOpacity(0.04)
        : AppColors.error.withOpacity(0.04);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── رقم السؤال + نص السؤال ──────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    answer.questionText,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  answer.isCorrect ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // ── إجابة الطالب ─────────────────────────────
            _buildAnswerRow(
              label: 'إجابة الطالب',
              value: answer.selectedAnswerText,
              isCorrect: answer.isCorrect,
              showBadge: true,
            ),

            // ── الإجابة الصحيحة (فقط إذا أخطأ) ─────────
            if (!answer.isCorrect) ...[
              const SizedBox(height: 6),
              _buildAnswerRow(
                label: 'الإجابة الصحيحة',
                value: answer.correctAnswerText,
                isCorrect: true,
                showBadge: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow({
    required String label,
    required String value,
    required bool isCorrect,
    required bool showBadge,
  }) {
    final color = isCorrect ? AppColors.success : AppColors.error;
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (showBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              isCorrect ? '✓ صح' : '✗ خطأ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}
