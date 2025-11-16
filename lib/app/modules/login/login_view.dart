import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../routes/app_routes.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

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

                const SizedBox(height: 30),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: _buildTitle(),
                ),

                const SizedBox(height: 15),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 400),
                  child: _buildEmailField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 500),
                  child: _buildPasswordField(),
                ),

                const SizedBox(height: 12),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 600),
                  child: _buildRememberAndForgot(),
                ),

                const SizedBox(height: 32),

                AnimatedWidgets.scaleIn(
                  delay: const Duration(milliseconds: 700),
                  child: _buildLoginButton(),
                ),

                const SizedBox(height: 24),

                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 900),
                  child: _buildSignUpLink(),
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
          child: const Icon(Icons.school, size: 60, color: Colors.white),
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
        'سجل دخولك للمتابعة',
        style: AppTextStyles.h4.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,

            decoration: InputDecoration(
              labelStyle: TextStyle(color: Color(0xFF493Ad5)),
              hintStyle: TextStyle(color: Color(0xFF493Ad5)),
              labelText: 'البريد الإلكتروني',
              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF493Ad5)),

              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            validator: controller.validatePassword,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Color(0xFF493Ad5)),
              hintStyle: TextStyle(color: Color(0xFF493Ad5)),

              focusColor: Color(0xFF493Ad5),
              labelText: 'كلمة المرور',
              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF493Ad5)),
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
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return AnimatedWidgets.fadeIn(
      delay: const Duration(milliseconds: 800),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            Get.snackbar(
              'قريباً',
              'ميزة استعادة كلمة المرور قريباً',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Text(
            'نسيت كلمة المرور؟',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Color(0xFF493Ad5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => AnimatedWidgets.bounceButton(
        onTap: controller.isLoading.value ? () {} : controller.login,
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
                      'تسجيل الدخول',
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

  Widget _buildSignUpLink() {
    return Center(
      child: AnimatedWidgets.bounceButton(
        onTap: () => Get.toNamed(AppRoutes.signup),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            Text.rich(
              TextSpan(
                text: 'ليس لديك حساب؟ ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Color(0xFF493Ad5),
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'سجل الآن',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Color(0xFF493Ad5),
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
