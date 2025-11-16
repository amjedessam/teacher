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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                AnimatedWidgets.scaleIn(
                  duration: const Duration(milliseconds: 800),
                  child: _buildLogo(),
                ),

                const SizedBox(height: 20),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: _buildTitle(),
                ),

                const SizedBox(height: 15),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,

                  delay: const Duration(milliseconds: 400),
                  child: _buildNameField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 450),
                  child: _buildEmailField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 500),
                  child: _buildPhoneField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 550),
                  child: _buildSchoolField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 600),
                  child: _buildPasswordField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 650),

                  child: _buildConfirmPasswordField(),
                ),

                const SizedBox(height: 20),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 700),
                  child: _buildSubjectsSection(),
                ),

                const SizedBox(height: 20),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 750),
                  child: _buildTermsCheckbox(),
                ),

                const SizedBox(height: 32),

                AnimatedWidgets.scaleIn(
                  delay: const Duration(milliseconds: 800),
                  child: _buildSignUpButton(),
                ),

                const SizedBox(height: 24),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 900),
                  child: _buildLoginLink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_alt_1,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'المعلم الذكي',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,

            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        'إنشاء حساب جديد',
        style: AppTextStyles.h4.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextFormField(
        controller: controller.nameController,
        validator: controller.validateName,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Color(0xFF493Ad5)),
          hintStyle: TextStyle(color: Color(0xFF493Ad5)),
          labelText: 'الاسم الكامل',
          prefixIcon: Icon(Icons.person_outline, color: Color(0xFF493Ad5)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: controller.validateEmail,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Color(0xFF493Ad5)),
          hintStyle: TextStyle(color: Color(0xFF493Ad5)),
          labelText: 'البريد الإلكتروني',
          prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF493Ad5)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextFormField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        validator: controller.validatePhone,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Color(0xFF493Ad5)),
          hintStyle: TextStyle(color: Color(0xFF493Ad5)),
          labelText: 'رقم الهاتف',
          prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF493Ad5)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSchoolField() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: TextFormField(
        controller: controller.schoolController,
        validator: controller.validateSchool,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Color(0xFF493Ad5)),
          hintStyle: TextStyle(color: Color(0xFF493Ad5)),
          labelText: 'المدرسة',
          prefixIcon: Icon(Icons.school_outlined, color: Color(0xFF493Ad5)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        obscureText: controller.obscurePassword.value,
        validator: controller.validatePassword,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Color(0xFF493Ad5)),
          hintStyle: const TextStyle(color: Color(0xFF493Ad5)),
          focusColor: const Color(0xFF493Ad5),
          labelText: 'كلمة المرور',
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF493Ad5)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,

          suffixIcon: IconButton(
            icon: Icon(
              controller.obscurePassword.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.primary,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.confirmPasswordController,
        obscureText: controller.obscureConfirmPassword.value,
        validator: controller.validateConfirmPassword,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Color(0xFF493Ad5)),
          hintStyle: const TextStyle(color: Color(0xFF493Ad5)),
          focusColor: const Color(0xFF493Ad5),
          labelText: 'تأكيد كلمة المرور',
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF493Ad5)),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscureConfirmPassword.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.primary,
            ),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 12),
          child: Row(
            children: [
              const Icon(
                Icons.book_outlined,
                color: Color(0xFF493Ad5),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'المواد التي تدرسها',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF493Ad5),

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.availableSubjects.map((subject) {
              final isSelected = controller.selectedSubjects.contains(subject);
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
                          color: isSelected ? Colors.white : AppColors.primary,
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
                      : const Color(0xFF493Ad5).withOpacity(0.5),
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF493Ad5),
                  ),
                  children: [
                    TextSpan(
                      text: 'الشروط والأحكام',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF493Ad5),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' و'),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF493Ad5),
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
      child: AnimatedWidgets.bounceButton(
        onTap: controller.goToLogin,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            Text.rich(
              TextSpan(
                text: 'لديك حساب بالفعل؟ ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF493Ad5),
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'سجل دخولك',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF493Ad5),

                      fontWeight: FontWeight.bold,
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
}
