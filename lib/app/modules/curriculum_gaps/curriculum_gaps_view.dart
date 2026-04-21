// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import 'curriculum_gaps_controller.dart';

// class CurriculumGapsView extends GetView<CurriculumGapsController> {
//   const CurriculumGapsView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: Text('الفجوات المنهجية', style: AppTextStyles.h3),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: controller.reanalyze,
//             tooltip: 'إعادة التحليل',
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.chapterGaps.isEmpty) {
//           return _buildEmptyState();
//         }
//         return RefreshIndicator(
//           onRefresh: controller.loadGaps,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── إحصائيات سريعة ──────────────────────
//                 _buildSummaryCards(),
//                 const SizedBox(height: 20),

//                 // ── فلتر الخطورة ─────────────────────────
//                 _buildSeverityFilter(),
//                 const SizedBox(height: 16),

//                 // ── قائمة الفصول ─────────────────────────
//                 Text('تحليل الفصول الدراسية', style: AppTextStyles.h4),
//                 const SizedBox(height: 12),
//                 Obx(
//                   () => Column(
//                     children: controller.filteredChapterGaps
//                         .map((gap) => _buildChapterCard(gap))
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   // ── إحصائيات سريعة ──────────────────────────────────────
//   Widget _buildSummaryCards() {
//     return Obx(
//       () => Row(
//         children: [
//           _buildStatCard(
//             '${controller.totalChapters}',
//             'فصل محلّل',
//             Icons.book_outlined,
//             AppColors.primary,
//           ),
//           const SizedBox(width: 12),
//           _buildStatCard(
//             '${controller.criticalCount}',
//             'حرج',
//             Icons.warning_rounded,
//             const Color(0xFFF44336),
//           ),
//           const SizedBox(width: 12),
//           _buildStatCard(
//             '${controller.totalWeakQuestions}',
//             'سؤال ضعيف',
//             Icons.quiz_outlined,
//             const Color(0xFFFF9800),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String value,
//     String label,
//     IconData icon,
//     Color color,
//   ) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 22),
//             const SizedBox(height: 6),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             Text(
//               label,
//               style: AppTextStyles.caption,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── فلتر الخطورة ─────────────────────────────────────────
//   Widget _buildSeverityFilter() {
//     return Obx(
//       () => SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _buildFilterChip(
//               label: 'الكل',
//               isSelected: controller.selectedSeverity.value == null,
//               onTap: () => controller.filterBySeverity(null),
//               color: AppColors.primary,
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               label: 'حرج',
//               isSelected:
//                   controller.selectedSeverity.value == GapSeverity.critical,
//               onTap: () => controller.filterBySeverity(GapSeverity.critical),
//               color: const Color(0xFFF44336),
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               label: 'مرتفع',
//               isSelected: controller.selectedSeverity.value == GapSeverity.high,
//               onTap: () => controller.filterBySeverity(GapSeverity.high),
//               color: const Color(0xFFFF9800),
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               label: 'متوسط',
//               isSelected:
//                   controller.selectedSeverity.value == GapSeverity.medium,
//               onTap: () => controller.filterBySeverity(GapSeverity.medium),
//               color: AppColors.secondaryLight,
//             ),
//             const SizedBox(width: 8),
//             _buildFilterChip(
//               label: 'منخفض',
//               isSelected: controller.selectedSeverity.value == GapSeverity.low,
//               onTap: () => controller.filterBySeverity(GapSeverity.low),
//               color: const Color(0xFF4CAF50),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChip({
//     required String label,
//     required bool isSelected,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? color : color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? color : color.withOpacity(0.3),
//           ),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: isSelected ? Colors.white : color,
//           ),
//         ),
//       ),
//     );
//   }

//   // ── بطاقة الفصل ──────────────────────────────────────────
//   Widget _buildChapterCard(ChapterGap gap) {
//     final color = controller.getSeverityColor(gap.severity);
//     final isExpanded = false.obs;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border(right: BorderSide(color: color, width: 4)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // ── Header ───────────────────────────────────
//           InkWell(
//             onTap: () => isExpanded.value = !isExpanded.value,
//             borderRadius: BorderRadius.circular(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               gap.chapterName,
//                               style: AppTextStyles.bodyMedium.copyWith(
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               gap.subjectName,
//                               style: AppTextStyles.caption.copyWith(
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // badge الخطورة
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: color.withOpacity(0.3)),
//                         ),
//                         child: Text(
//                           controller.getSeverityLabel(gap.severity),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: color,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Obx(
//                         () => Icon(
//                           isExpanded.value
//                               ? Icons.keyboard_arrow_up
//                               : Icons.keyboard_arrow_down,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   // شريط نسبة الفشل
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('متوسط نسبة الفشل', style: AppTextStyles.bodySmall),
//                       Text(
//                         '${gap.avgFailureRate.toStringAsFixed(0)}%',
//                         style: AppTextStyles.labelBold.copyWith(color: color),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     child: LinearProgressIndicator(
//                       value: gap.avgFailureRate / 100,
//                       minHeight: 8,
//                       backgroundColor: color.withOpacity(0.15),
//                       valueColor: AlwaysStoppedAnimation<Color>(color),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // إحصائيات سريعة
//                   Row(
//                     children: [
//                       _buildMiniStat(
//                         '${gap.questions.length}',
//                         'سؤال',
//                         AppColors.primary,
//                       ),
//                       const SizedBox(width: 16),
//                       _buildMiniStat(
//                         '${gap.weakQuestionsCount}',
//                         'سؤال ضعيف',
//                         color,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ── التوصية + تفاصيل الأسئلة ─────────────────
//           Obx(
//             () => isExpanded.value
//                 ? Column(
//                     children: [
//                       const Divider(height: 1),
//                       // التوصية
//                       Container(
//                         margin: const EdgeInsets.all(16),
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.05),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: color.withOpacity(0.2)),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.lightbulb_outline,
//                               color: color,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 gap.recommendation,
//                                 style: AppTextStyles.bodySmall,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // قائمة الأسئلة
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'تفاصيل الأسئلة',
//                               style: AppTextStyles.labelBold,
//                             ),
//                             const SizedBox(height: 8),
//                             ...gap.questions.map((q) => _buildQuestionRow(q)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionRow(QuestionGap q) {
//     final qColor = controller.getSeverityColor(q.severity);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: qColor.withOpacity(0.04),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: qColor.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   q.questionText,
//                   style: AppTextStyles.bodySmall.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${q.totalStudents} طالب • ${q.failedStudents} أخطأ',
//                   style: AppTextStyles.caption.copyWith(
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: qColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               '${q.failureRate.toStringAsFixed(0)}%',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: qColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMiniStat(String value, String label, Color color) {
//     return Row(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.check_circle_outline,
//               size: 80,
//               color: AppColors.success.withOpacity(0.5),
//             ),
//             const SizedBox(height: 24),
//             Text('لا توجد فجوات منهجية', style: AppTextStyles.h3),
//             const SizedBox(height: 8),
//             Text(
//               'أداء الطلاب جيد في جميع الفصول المدروسة',
//               style: AppTextStyles.bodyMedium.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/data/models/gapModel.dart';
import '../../core/theme/app_colors.dart'; // تأكد من المسارات لديك
import '../../core/theme/app_text_styles.dart';
import 'curriculum_gaps_controller.dart';

class CurriculumGapsView extends GetView<CurriculumGapsController> {
  const CurriculumGapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('الفجوات المنهجية', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF7C74FF)),
            onPressed: controller.reanalyze,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildSeverityFilter(),
              const SizedBox(height: 20),
              const Text('تحليل الفصول الدراسية', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredChapterGaps.length,
                itemBuilder: (context, index) {
                  return _buildChapterCard(controller.filteredChapterGaps[index]);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _buildStatCard('${controller.totalChapters}', 'فصل محلّل', Icons.book_outlined, const Color(0xFF7C74FF)),
        const SizedBox(width: 10),
        _buildStatCard('${controller.criticalCount}', 'حرج', Icons.warning_amber_rounded, const Color(0xFFF44336)),
        const SizedBox(width: 10),
        _buildStatCard('${controller.totalWeakQuestions}', 'سؤال ضعيف', Icons.quiz_outlined, const Color(0xFFFF9800)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip("الكل", null, const Color(0xFF7C74FF)),
          _buildFilterChip("حرج", GapSeverity.critical, const Color(0xFFF44336)),
          _buildFilterChip("مرتفع", GapSeverity.high, const Color(0xFFFF9800)),
          _buildFilterChip("متوسط", GapSeverity.medium, const Color(0xFF2196F3)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, GapSeverity? severity, Color color) {
    return Obx(() {
      bool isSelected = controller.selectedSeverity.value == severity;
      return GestureDetector(
        onTap: () => controller.filterBySeverity(severity),
        child: Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? color : color.withOpacity(0.3)),
          ),
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.bold,fontSize: 18)),
        ),
      );
    });
  }

  Widget _buildChapterCard(ChapterGap gap) {
    final color = controller.getSeverityColor(gap.severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(right: BorderSide(color: color, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => gap.isExpanded.toggle(),
            contentPadding: const EdgeInsets.all(16),
            title: Text(gap.chapterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("نسبة الفشل", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    Text("${gap.avgFailureRate.toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: gap.avgFailureRate / 100,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 6,
                ),
              ],
            ),
            trailing: Obx(() => Icon(gap.isExpanded.value ? Icons.expand_less : Icons.expand_more)),
          ),
          Obx(() => gap.isExpanded.value 
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb, color: color, size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text(gap.recommendation, style: const TextStyle(fontSize: 16, height: 1.4))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...gap.questions.map((q) => _buildQuestionItem(q, color)).toList(),
                  ],
                ),
              )
            : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(QuestionGap q, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: Text(q.questionText, style: const TextStyle(fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text("${q.failureRate.toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}