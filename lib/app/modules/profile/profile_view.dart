import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final teacher = controller.teacher.value;

        if (teacher == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري تحميل البيانات...'),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
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
                        const SizedBox(height: 35),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              teacher.profileImage.isNotEmpty
                                  ? teacher.profileImage
                                  : '👨‍🏫',
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Column(
                          children: [
                            Text(
                              ' ${teacher.name} :',
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              teacher.subjects.isNotEmpty
                                  ? 'معلم ${teacher.subjects.join(", ")}'
                                  : 'معلم',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'الطلاب',
                            value: '${teacher.totalStudents}',
                            icon: Icons.people,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 'الفصول',
                            value: '${teacher.totalClasses}',
                            icon: Icons.class_,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 'المعدل',
                            value:
                                '${teacher.averageScore.toStringAsFixed(1)}%',
                            icon: Icons.star,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text('المعلومات الشخصية', style: AppTextStyles.h4),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      title: 'رقم الهاتف',
                      value: teacher.phone,
                    ),
                    _buildInfoCard(
                      icon: Icons.email_outlined,
                      title: 'البريد الإلكتروني',
                      value: teacher.email,
                    ),
                    _buildInfoCard(
                      icon: Icons.badge_outlined,
                      title: 'رقم الموظف',
                      value: teacher.employeeId,
                    ),
                    _buildInfoCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'تاريخ الانضمام',
                      value: _formatDate(teacher.joinedDate),
                    ),

                    const SizedBox(height: 24),

                    Text('الإعدادات', style: AppTextStyles.h4),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      title: 'تعديل الملف الشخصي',
                      onTap: () {
                        Get.snackbar(
                          'قريباً',
                          'ميزة تعديل الملف الشخصي قريباً',
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.lock_outline,
                      title: 'تغيير كلمة المرور',
                      onTap: () {
                        Get.snackbar('قريباً', 'ميزة تغيير كلمة المرور قريباً');
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.notifications_outlined,
                      title: 'إعدادات الإشعارات',
                      onTap: () {
                        Get.snackbar('قريباً', 'إعدادات الإشعارات قريباً');
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.help_outline,
                      title: 'المساعدة والدعم',
                      onTap: () {
                        Get.snackbar(
                          'المساعدة',
                          'للدعم تواصل معنا على 774353045 ',
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.info_outline,
                      title: 'حول التطبيق',
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('حول التطبيق'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('تطبيق المعلم', style: AppTextStyles.h4),
                                const SizedBox(height: 8),
                                Text(
                                  'مبرمج التطبيق : Amjed Essam ',
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '          تطبيق المعلم ',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('حسناً'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: controller.logout,
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: Text(
                          'تسجيل الخروج',
                          style: AppTextStyles.button.copyWith(
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
