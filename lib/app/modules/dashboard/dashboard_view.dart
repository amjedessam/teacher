// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import '../../routes/app_routes.dart';
// import 'dashboard_controller.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refreshData,
//           child: CustomScrollView(
//             slivers: [
//               // App Bar
//               SliverAppBar(
//                 floating: true,
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 expandedHeight: 120,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: AppColors.primaryGradient,
//                     ),
//                     child: SafeArea(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "مرحبا استاذ :",
//                                         style: AppTextStyles.bodyMedium
//                                             .copyWith(
//                                               color: Colors.white.withOpacity(
//                                                 0.9,
//                                               ),
//                                             ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         controller.teacher.value?.name ?? '',
//                                         style: AppTextStyles.h2.copyWith(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Notifications Badge
//                                 Stack(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         Get.toNamed(AppRoutes.notifications);
//                                       },
//                                       icon: const Icon(
//                                         Icons.notifications_outlined,
//                                         color: Colors.white,
//                                         size: 28,
//                                       ),
//                                     ),
//                                     if (controller
//                                             .unreadNotificationsCount
//                                             .value >
//                                         0)
//                                       Positioned(
//                                         right: 8,
//                                         top: 8,
//                                         child: Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: const BoxDecoration(
//                                             color: AppColors.error,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           constraints: const BoxConstraints(
//                                             minWidth: 20,
//                                             minHeight: 20,
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               '${controller.unreadNotificationsCount.value}',
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // Content
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Quick Stats
//                       _buildQuickStats(),

//                       const SizedBox(height: 24),

//                       // Weekly Progress
//                       _buildWeeklyProgress(),

//                       const SizedBox(height: 24),

//                       // Subject Performance
//                       _buildSubjectPerformance(),

//                       const SizedBox(height: 24),

//                       // Quick Actions
//                       _buildQuickActions(),

//                       const SizedBox(height: 24),

//                       // Recent Activities
//                       _buildRecentActivities(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildQuickStats() {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       childAspectRatio: 1.5,
//       children: [
//         _buildStatCard(
//           title: 'إجمالي الطلاب',
//           value: '${controller.dashboardStats['totalStudents']}',
//           icon: Icons.people,
//           gradient: AppColors.primaryGradient,
//         ),
//         _buildStatCard(
//           title: 'الفصول الدراسية',
//           value: '${controller.dashboardStats['totalClasses']}',
//           icon: Icons.class_,
//           gradient: AppColors.successGradient,
//         ),
//         _buildStatCard(
//           title: 'متوسط الدرجات',
//           value: '${controller.dashboardStats['averageScore']}%',
//           icon: Icons.trending_up,
//           gradient: AppColors.warningGradient,
//         ),
//         _buildStatCard(
//           title: 'الاختبارات',
//           value: '${controller.dashboardStats['completedQuizzes']}',
//           icon: Icons.quiz,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required LinearGradient gradient,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: gradient.colors.first.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(3),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: Colors.white, size: 24),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: AppTextStyles.displayMedium.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   title,
//                   style: AppTextStyles.bodySmall.copyWith(
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeeklyProgress() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowLight,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('التقدم الأسبوعي', style: AppTextStyles.h4),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.success.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.trending_up,
//                       color: AppColors.success,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '+12%',
//                       style: AppTextStyles.bodySmall.copyWith(
//                         color: AppColors.success,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 160,
//             child: _buildSimpleChart(),
//             // _buildSimpleChart()),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildSimpleChart() {
//   //   final data = controller.weeklyProgressData;
//   //   if (data.isEmpty) return const SizedBox();

//   //   return LayoutBuilder(
//   //     builder: (context, constraints) {
//   //       final maxValue = data.reduce((a, b) => a > b ? a : b);

//   //       final barWidth = constraints.maxWidth / data.length - 16;
//   //       return Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //         crossAxisAlignment: CrossAxisAlignment.end,
//   //         children: List.generate(data.length, (index) {
//   //           final height = (data[index] / maxValue) * constraints.maxHeight;
//   //           final days = [
//   //             'السبت',
//   //             'الأحد',
//   //             'الإثنين',
//   //             'الثلاثاء',
//   //             'الأربعاء',
//   //             'الخميس',
//   //             'الجمعة',
//   //           ];

//   //           return Column(
//   //             mainAxisAlignment: MainAxisAlignment.end,
//   //             children: [
//   //               Container(
//   //                 width: barWidth,
//   //                 height: height,
//   //                 decoration: BoxDecoration(
//   //                   gradient: AppColors.primaryGradient,
//   //                   borderRadius: BorderRadius.circular(8),
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 8),
//   //               Text(days[index].substring(0, 2), style: AppTextStyles.caption),
//   //             ],
//   //           );
//   //         }),
//   //       );
//   //     },
//   //   );
//   // }

//   Widget _buildSimpleChart() {
//     final data = controller.weeklyProgressData;
//     if (data.isEmpty) return const SizedBox();

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final maxValue = data.reduce((a, b) => a > b ? a : b);

//         // نخصم مساحة مخصصة للنص (label) و الـ spacing حتى لا يحدث overflow
//         const double labelHeight = 18; // تقريباً ارتفاع السطر النصي
//         const double labelSpacing = 8; // المسافة بين العمود والنص
//         final double availableHeight =
//             (constraints.maxHeight - labelHeight - labelSpacing).clamp(
//               0.0,
//               constraints.maxHeight,
//             );

//         // حساب عرض العمود بشكل آمن
//         final int itemCount = data.length;
//         final double totalGap = (itemCount - 1) * 8.0; // الفجوات بين الأعمدة
//         final double barWidth = ((constraints.maxWidth - totalGap) / itemCount)
//             .clamp(8.0, constraints.maxWidth);

//         final days = [
//           'السبت',
//           'الأحد',
//           'الإثنين',
//           'الثلاثاء',
//           'الأربعاء',
//           'الخمس',
//           'الجمعة',
//         ];

//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: List.generate(itemCount, (index) {
//             // اجعل الارتفاع محسوب من المساحة المتاحة (لا تتجاوز)
//             final double height = maxValue > 0
//                 ? (data[index] / maxValue) * availableHeight
//                 : 0.0;
//             // final double height = maxValue > 0
//             //     ? (data[index] / maxValue) * (availableHeight - 10)
//             //     : 0.0;

//             // final label = days.length > index
//             //     ? days[index].substring(0, 2)
//             //     : '';
//             final label = days.length > index ? days[index] : '';
//             return SizedBox(
//               width: barWidth,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // العمود نفسه، نستخدم SizedBox لتثبيت العرض
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 600),
//                     curve: Curves.easeOutCubic,
//                     width: double.infinity,
//                     height: height,
//                     decoration: BoxDecoration(
//                       gradient: AppColors.primaryGradient,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: labelSpacing),
//                   // النص لا يسبب overflow لأنه ضمن المساحة المحسوبة
//                   Text(
//                     label,
//                     style: AppTextStyles.caption.copyWith(
//                       color: Theme.of(context).brightness == Brightness.dark
//                           ? Colors.grey[300]
//                           : Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }

//   Widget _buildSubjectPerformance() {
//     final subjects = controller.subjectPerformanceData;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowLight,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('أداء المواضيع', style: AppTextStyles.h4),
//           const SizedBox(height: 20),
//           ...subjects
//               .map(
//                 (subject) => Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             subject['subject'],
//                             style: AppTextStyles.bodyMedium,
//                           ),
//                           Text(
//                             '${subject['average'].toStringAsFixed(1)}%',
//                             style: AppTextStyles.labelBold.copyWith(
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: LinearProgressIndicator(
//                           value: subject['average'] / 100,
//                           minHeight: 8,
//                           backgroundColor: AppColors.border,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             _getPerformanceColor(subject['average']),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Color _getPerformanceColor(double score) {
//     if (score >= 85) return AppColors.success;
//     if (score >= 70) return AppColors.warning;
//     return AppColors.error;
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('إجراءات سريعة', style: AppTextStyles.h4),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionButton(
//                 title: 'إضافة سؤال',
//                 icon: Icons.add_circle_outline,
//                 color: AppColors.primary,
//                 onTap: () => Get.toNamed(AppRoutes.addQuestion),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildActionButton(
//                 title: 'بناء اختبار',
//                 icon: Icons.auto_awesome,
//                 color: AppColors.secondary,
//                 onTap: () => Get.toNamed(AppRoutes.quizBuilder),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionButton(
//                 title: 'التقارير',
//                 icon: Icons.analytics_outlined,
//                 color: AppColors.warning,
//                 onTap: () => Get.toNamed(AppRoutes.reports),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildActionButton(
//                 title: 'جودة الأسئلة',
//                 icon: Icons.verified_outlined,
//                 color: AppColors.info,
//                 onTap: () => Get.toNamed(AppRoutes.questionQuality),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: AppTextStyles.bodyMedium.copyWith(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 16, color: color),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentActivities() {
//     final recentNotifications = controller.notifications.take(3).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('النشاطات الأخيرة', style: AppTextStyles.h4),
//             TextButton(
//               onPressed: () => Get.toNamed(AppRoutes.notifications),
//               child: Text(
//                 'عرض الكل',
//                 style: AppTextStyles.bodySmall.copyWith(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...recentNotifications
//             .map(
//               (notification) => Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: notification.isRead
//                         ? AppColors.border
//                         : AppColors.primary.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: _getNotificationColor(
//                           notification.type,
//                         ).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         _getNotificationIcon(notification.type),
//                         color: _getNotificationColor(notification.type),
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             notification.title,
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             notification.message,
//                             style: AppTextStyles.bodySmall,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//       ],
//     );
//   }

//   IconData _getNotificationIcon(String type) {
//     switch (type) {
//       case 'quiz_completed':
//         return Icons.check_circle_outline;
//       case 'low_performance':
//         return Icons.warning_amber_outlined;
//       case 'new_student':
//         return Icons.person_add_outlined;
//       default:
//         return Icons.info_outline;
//     }
//   }

//   Color _getNotificationColor(String type) {
//     switch (type) {
//       case 'quiz_completed':
//         return AppColors.success;
//       case 'low_performance':
//         return AppColors.warning;
//       case 'new_student':
//         return AppColors.info;
//       default:
//         return AppColors.textSecondary;
//     }
//   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import '../../routes/app_routes.dart';
// import 'dashboard_controller.dart';

// class DashboardView extends GetView<DashboardController> {
//   // ✅ الحل هنا
//   const DashboardView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return RefreshIndicator(
//           onRefresh: controller.refreshData,
//           child: CustomScrollView(
//             slivers: [
//               // App Bar
//               SliverAppBar(
//                 floating: true,
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 expandedHeight: 120,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     decoration: const BoxDecoration(
//                       gradient: AppColors.primaryGradient,
//                     ),
//                     child: SafeArea(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "مرحبا استاذ :",
//                                         style: AppTextStyles.bodyMedium
//                                             .copyWith(
//                                               color: Colors.white.withOpacity(
//                                                 0.9,
//                                               ),
//                                             ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         controller.teacher.value?.name ?? '',
//                                         style: AppTextStyles.h2.copyWith(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Notifications Badge
//                                 Stack(
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         Get.toNamed(AppRoutes.notifications);
//                                       },
//                                       icon: const Icon(
//                                         Icons.notifications_outlined,
//                                         color: Colors.white,
//                                         size: 28,
//                                       ),
//                                     ),
//                                     if (controller
//                                             .unreadNotificationsCount
//                                             .value >
//                                         0)
//                                       Positioned(
//                                         right: 8,
//                                         top: 8,
//                                         child: Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: const BoxDecoration(
//                                             color: AppColors.error,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           constraints: const BoxConstraints(
//                                             minWidth: 20,
//                                             minHeight: 20,
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               '${controller.unreadNotificationsCount.value}',
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // Content
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Quick Stats
//                       _buildQuickStats(),

//                       const SizedBox(height: 24),

//                       // Weekly Progress
//                       _buildWeeklyProgress(),

//                       const SizedBox(height: 24),

//                       // Subject Performance
//                       _buildSubjectPerformance(),

//                       const SizedBox(height: 24),

//                       // Quick Actions
//                       _buildQuickActions(),

//                       const SizedBox(height: 24),

//                       // Recent Activities
//                       _buildRecentActivities(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildQuickStats() {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       childAspectRatio: 1.5,
//       children: [
//         _buildStatCard(
//           title: 'إجمالي الطلاب',
//           value: '${controller.dashboardStats['totalStudents']}',
//           icon: Icons.people,
//           gradient: AppColors.primaryGradient,
//         ),
//         _buildStatCard(
//           title: 'الفصول الدراسية',
//           value: '${controller.dashboardStats['totalClasses']}',
//           icon: Icons.class_,
//           gradient: AppColors.successGradient,
//         ),
//         _buildStatCard(
//           title: 'متوسط الدرجات',
//           value: '${controller.dashboardStats['averageScore']}%',
//           icon: Icons.trending_up,
//           gradient: AppColors.warningGradient,
//         ),
//         _buildStatCard(
//           title: 'الاختبارات',
//           value: '${controller.dashboardStats['completedQuizzes']}',
//           icon: Icons.quiz,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required LinearGradient gradient,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: gradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: gradient.colors.first.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(3),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: Colors.white, size: 24),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: AppTextStyles.displayMedium.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   title,
//                   style: AppTextStyles.bodySmall.copyWith(
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeeklyProgress() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowLight,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('التقدم الأسبوعي', style: AppTextStyles.h4),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.success.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.trending_up,
//                       color: AppColors.success,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '+12%',
//                       style: AppTextStyles.bodySmall.copyWith(
//                         color: AppColors.success,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           SizedBox(height: 150, child: _buildSimpleChart()),
//         ],
//       ),
//     );
//   }

//   Widget _buildSimpleChart() {
//     final data = controller.weeklyProgressData;
//     if (data.isEmpty) return const SizedBox();

//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: false),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 const days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
//                 if (value.toInt() >= 0 && value.toInt() < days.length) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Text(
//                       days[value.toInt()],
//                       style: AppTextStyles.caption,
//                     ),
//                   );
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         lineBarsData: [
//           LineChartBarData(
//             spots: data.asMap().entries.map((entry) {
//               return FlSpot(entry.key.toDouble(), entry.value);
//             }).toList(),
//             isCurved: true,
//             gradient: AppColors.primaryGradient,
//             barWidth: 4,
//             isStrokeCapRound: true,
//             dotData: FlDotData(
//               show: true,
//               getDotPainter: (spot, percent, barData, index) {
//                 return FlDotCirclePainter(
//                   radius: 6,
//                   color: Colors.white,
//                   strokeWidth: 3,
//                   strokeColor: AppColors.primary,
//                 );
//               },
//             ),
//             belowBarData: BarAreaData(
//               show: true,
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primary.withOpacity(0.3),
//                   AppColors.primary.withOpacity(0.0),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//         ],
//         lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//             tooltipBgColor: AppColors.primary,
//             // getTooltipColor: (LineBarSpot touchedSpot) => AppColors.primary,
//             tooltipRoundedRadius: 8,
//             // tooltipBorderRadius: BorderRadius.circular(8),
//             getTooltipItems: (touchedSpots) {
//               return touchedSpots.map((spot) {
//                 return LineTooltipItem(
//                   '${spot.y.toInt()}%',
//                   const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               }).toList();
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubjectPerformance() {
//     final subjects = controller.subjectPerformanceData;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowLight,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('أداء المواضيع', style: AppTextStyles.h4),
//           const SizedBox(height: 20),
//           ...subjects
//               .map(
//                 (subject) => Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             subject['subject'],
//                             style: AppTextStyles.bodyMedium,
//                           ),
//                           Text(
//                             '${subject['average'].toStringAsFixed(1)}%',
//                             style: AppTextStyles.labelBold.copyWith(
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: LinearProgressIndicator(
//                           value: subject['average'] / 100,
//                           minHeight: 8,
//                           backgroundColor: AppColors.border,
//                           valueColor: AlwaysStoppedAnimation(
//                             _getPerformanceColor(subject['average']),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Color _getPerformanceColor(double score) {
//     if (score >= 85) return AppColors.success;
//     if (score >= 70) return AppColors.warning;
//     return AppColors.error;
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('إجراءات سريعة', style: AppTextStyles.h4),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionButton(
//                 title: 'إضافة سؤال',
//                 icon: Icons.add_circle_outline,
//                 color: AppColors.primary,
//                 onTap: () => Get.toNamed(AppRoutes.addQuestion),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildActionButton(
//                 title: 'بناء اختبار',
//                 icon: Icons.auto_awesome,
//                 color: AppColors.secondary,
//                 onTap: () => Get.toNamed(AppRoutes.quizBuilder),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionButton(
//                 title: 'التقارير',
//                 icon: Icons.analytics_outlined,
//                 color: AppColors.warning,
//                 onTap: () => Get.toNamed(AppRoutes.reports),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildActionButton(
//                 title: 'جودة الأسئلة',
//                 icon: Icons.verified_outlined,
//                 color: AppColors.info,
//                 onTap: () => Get.toNamed(AppRoutes.questionQuality),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: AppTextStyles.bodyMedium.copyWith(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 16, color: color),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecentActivities() {
//     final recentNotifications = controller.notifications.take(3).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('النشاطات الأخيرة', style: AppTextStyles.h4),
//             TextButton(
//               onPressed: () => Get.toNamed(AppRoutes.notifications),
//               child: Text(
//                 'عرض الكل',
//                 style: AppTextStyles.bodySmall.copyWith(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...recentNotifications
//             .map(
//               (notification) => Container(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: notification.isRead
//                         ? AppColors.border
//                         : AppColors.primary.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: _getNotificationColor(
//                           notification.type,
//                         ).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         _getNotificationIcon(notification.type),
//                         color: _getNotificationColor(notification.type),
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             notification.title,
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             notification.message,
//                             style: AppTextStyles.bodySmall,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//       ],
//     );
//   }

//   IconData _getNotificationIcon(String type) {
//     switch (type) {
//       case 'quiz_completed':
//         return Icons.check_circle_outline;
//       case 'low_performance':
//         return Icons.warning_amber_outlined;
//       case 'new_student':
//         return Icons.person_add_outlined;
//       default:
//         return Icons.info_outline;
//     }
//   }

//   Color _getNotificationColor(String type) {
//     switch (type) {
//       case 'quiz_completed':
//         return AppColors.success;
//       case 'low_performance':
//         return AppColors.warning;
//       case 'new_student':
//         return AppColors.info;
//       default:
//         return AppColors.textSecondary;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/shimmer_widgets.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../routes/app_routes.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // ✨ Shimmer Loading
        if (controller.isLoading.value) {
          return ShimmerWidgets.dashboardShimmer();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // App Bar with Hero Animation
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'dashboard_header',
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ✨ Fade In Animation
                                        AnimatedWidgets.fadeIn(
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          child: Text(
                                            'مرحباً أستاذ :',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // ✨ Slide In Animation
                                        AnimatedWidgets.slideIn(
                                          direction: SlideDirection.left,
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          child: Text(
                                            controller.teacher.value?.name ??
                                                '',
                                            style: AppTextStyles.h2.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ✨ Scale In Animation for Badge
                                  AnimatedWidgets.scaleIn(
                                    delay: const Duration(milliseconds: 300),
                                    child: _buildNotificationBadge(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✨ Animated Grid - Quick Stats
                      _buildAnimatedQuickStats(),

                      const SizedBox(height: 24),

                      // ✨ Fade In - Weekly Progress
                      AnimatedWidgets.fadeIn(
                        delay: const Duration(milliseconds: 400),
                        child: _buildWeeklyProgress(),
                      ),

                      const SizedBox(height: 24),

                      // ✨ Slide In - Subject Performance
                      AnimatedWidgets.slideIn(
                        direction: SlideDirection.bottom,
                        delay: const Duration(milliseconds: 500),
                        child: _buildSubjectPerformance(),
                      ),

                      const SizedBox(height: 24),

                      // ✨ Scale In - Quick Actions
                      AnimatedWidgets.scaleIn(
                        delay: const Duration(milliseconds: 600),
                        child: _buildQuickActions(),
                      ),

                      const SizedBox(height: 24),

                      // ✨ Animated List - Recent Activities
                      _buildAnimatedRecentActivities(),
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

  // ✨ Animated Notification Badge
  Widget _buildNotificationBadge() {
    return Stack(
      children: [
        AnimatedWidgets.bounceButton(
          onTap: () => Get.toNamed(AppRoutes.notifications),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        if (controller.unreadNotificationsCount.value > 0)
          Positioned(
            right: 0,
            top: 0,
            child: AnimatedWidgets.pulse(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Center(
                  child: Text(
                    '${controller.unreadNotificationsCount.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ✨ Animated Quick Stats Grid
  Widget _buildAnimatedQuickStats() {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          delay: const Duration(milliseconds: 100),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _buildStatCard(
              title: 'إجمالي الطلاب',
              value: '${controller.dashboardStats['totalStudents']}',
              icon: Icons.people,
              gradient: AppColors.primaryGradient,
            ),
            _buildStatCard(
              title: 'الفصول الدراسية',
              value: '${controller.dashboardStats['totalClasses']}',
              icon: Icons.class_,
              gradient: AppColors.successGradient,
            ),
            _buildStatCard(
              title: 'متوسط الدرجات',
              value: '${controller.dashboardStats['averageScore']}%',
              icon: Icons.trending_up,
              gradient: AppColors.warningGradient,
            ),
            _buildStatCard(
              title: 'الاختبارات',
              value: '${controller.dashboardStats['completedQuizzes']}',
              icon: Icons.quiz,
              gradient: const LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✨ Animated Stat Card with Bounce
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required LinearGradient gradient,
  }) {
    return AnimatedWidgets.bounceButton(
      onTap: () {
        // Navigate to details or show dialog
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('التقدم الأسبوعي', style: AppTextStyles.h4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 150, child: _buildSimpleChart()),
        ],
      ),
    );
  }

  Widget _buildSimpleChart() {
    final data = controller.weeklyProgressData;
    if (data.isEmpty) return const SizedBox();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            gradient: AppColors.primaryGradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: AppColors.primary,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.primary,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    final subjects = controller.subjectPerformanceData;

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
          Text('أداء المواضيع', style: AppTextStyles.h4),
          const SizedBox(height: 20),
          ...subjects.asMap().entries.map((entry) {
            final index = entry.key;
            final subject = entry.value;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subject['subject'],
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              '${subject['average'].toStringAsFixed(1)}%',
                              style: AppTextStyles.labelBold.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0.0,
                            end: subject['average'] / 100,
                          ),
                          duration: Duration(milliseconds: 800 + (index * 100)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: value,
                                minHeight: 8,
                                backgroundColor: AppColors.border,
                                valueColor: AlwaysStoppedAnimation(
                                  _getPerformanceColor(subject['average']),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

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

  // ✨ Animated Recent Activities
  Widget _buildAnimatedRecentActivities() {
    final recentNotifications = controller.notifications.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('النشاطات الأخيرة', style: AppTextStyles.h4),
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
              children: recentNotifications.map((notification) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: notification.isRead
                          ? AppColors.border
                          : AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(
                            notification.type,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: _getNotificationColor(notification.type),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
