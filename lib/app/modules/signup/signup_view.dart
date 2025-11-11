import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_widgets.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ✨ Animated App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primary,
                ),
                onPressed: () => Get.back(),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ✨ Header with Animation
                      AnimatedWidgets.fadeIn(
                        duration: const Duration(milliseconds: 600),
                        child: _buildHeader(),
                      ),

                      const SizedBox(height: 40),

                      // ✨ Form Fields with Staggered Animation
                      _buildAnimatedForm(),

                      const SizedBox(height: 24),

                      // ✨ Subjects Selection
                      AnimatedWidgets.slideIn(
                        direction: SlideDirection.bottom,
                        delay: const Duration(milliseconds: 800),
                        child: _buildSubjectsSection(),
                      ),

                      const SizedBox(height: 24),

                      // ✨ Terms & Conditions
                      AnimatedWidgets.fadeIn(
                        delay: const Duration(milliseconds: 900),
                        child: _buildTermsCheckbox(),
                      ),

                      const SizedBox(height: 32),

                      // ✨ Sign Up Button
                      AnimatedWidgets.scaleIn(
                        delay: const Duration(milliseconds: 1000),
                        child: _buildSignUpButton(),
                      ),

                      const SizedBox(height: 24),

                      // ✨ Login Link
                      AnimatedWidgets.fadeIn(
                        delay: const Duration(milliseconds: 1100),
                        child: _buildLoginLink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_alt_1,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'إنشاء حساب جديد',
          style: AppTextStyles.h1.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8), // Subtitle
        Text(
          'املأ البيانات أدناه لإنشاء حسابك',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedForm() {
    final formFields = [
      // Name Field
      _buildTextField(
        controller: controller.nameController,
        label: 'الاسم الكامل',
        hint: 'أدخل اسمك الكامل',
        icon: Icons.person_outline,
        validator: controller.validateName,
      ),

      const SizedBox(height: 16),

      // Email Field
      _buildTextField(
        controller: controller.emailController,
        label: 'البريد الإلكتروني',
        hint: 'example@domain.com',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: controller.validateEmail,
      ),

      const SizedBox(height: 16),

      // Phone Field
      _buildTextField(
        controller: controller.phoneController,
        label: 'رقم الهاتف',
        hint: '05xxxxxxxx',
        icon: Icons.phone_outlined,
        keyboardType: TextInputType.phone,
        validator: controller.validatePhone,
      ),

      const SizedBox(height: 16),

      // School Field
      _buildTextField(
        controller: controller.schoolController,
        label: 'المدرسة',
        hint: 'اسم المدرسة',
        icon: Icons.school_outlined,
        validator: controller.validateSchool,
      ),

      const SizedBox(height: 16),

      // Password Field
      Obx(
        () => _buildTextField(
          controller: controller.passwordController,
          label: 'كلمة المرور',
          hint: '••••••••',
          icon: Icons.lock_outline,
          obscureText: controller.obscurePassword.value,
          validator: controller.validatePassword,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscurePassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Confirm Password Field
      Obx(
        () => _buildTextField(
          controller: controller.confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          hint: '••••••••',
          icon: Icons.lock_outline,
          obscureText: controller.obscureConfirmPassword.value,
          validator: controller.validateConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscureConfirmPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
        ),
      ),
    ];

    return Column(
      children: formFields.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        return AnimatedWidgets.slideIn(
          direction: SlideDirection.right,
          delay: Duration(milliseconds: 200 + (index * 50)),
          child: widget,
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelBold.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: AppColors.primary),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.book_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('المواد التي تدرسها', style: AppTextStyles.labelBold),
                    Text(
                      'اختر مادة أو أكثر',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.availableSubjects.map((subject) {
                final isSelected = controller.selectedSubjects.contains(
                  subject,
                );
                return AnimatedWidgets.bounceButton(
                  onTap: () => controller.toggleSubject(subject),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                        if (isSelected) const SizedBox(width: 6),
                        Text(
                          subject,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Obx(
      () => AnimatedWidgets.bounceButton(
        onTap: () => controller.toggleTerms(!controller.acceptTerms.value),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: controller.acceptTerms.value
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: controller.acceptTerms.value
                      ? AppColors.primary
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: controller.acceptTerms.value
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'أوافق على ',
                  style: AppTextStyles.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'الشروط والأحكام',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' و'),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Obx(
      () => AnimatedWidgets.bounceButton(
        onTap: controller.isLoading.value ? () {} : controller.signUp,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: controller.isLoading.value
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add_alt_1, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'إنشاء حساب',
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: controller.goToLogin,
        child: Text.rich(
          TextSpan(
            text: 'لديك حساب بالفعل؟ ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: 'تسجيل الدخول',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
