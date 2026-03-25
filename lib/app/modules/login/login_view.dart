import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_widgets.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── خلفية متدرجة ─────────────────────────────────
          Container(
            height: size.height * 0.52,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF0D6EBD), Color(0xFF0A9396)],
              ),
            ),
          ),

          // ── الجزء السفلي ─────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.52,
              color: const Color(0xFFF5F7FA),
            ),
          ),

          // ── موجة فاصلة ───────────────────────────────────
          Positioned(
            top: size.height * 0.42,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF0D6EBD), Color(0xFF0A9396)],
                  ),
                ),
              ),
            ),
          ),

          // ── دوائر زخرفية ─────────────────────────────────
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── المحتوى ──────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 36),

                    // ── الشعار ─────────────────────────────
                    AnimatedWidgets.scaleIn(
                      duration: const Duration(milliseconds: 800),
                      child: _buildLogo(),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 16),

                        // اسم المنصة
                        const Text(
                          'منصة رُشد',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'بوابة المعلم',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // ── كارد النموذج ───────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D6EBD).withOpacity(0.12),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // عنوان الكارد
                            const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A2B4A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'مرحباً أستاذ، سجّل دخولك للمتابعة',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── حقل البريد ─────────────────
                            AnimatedWidgets.slideIn(
                              direction: SlideDirection.right,
                              delay: const Duration(milliseconds: 400),
                              child: _buildEmailField(),
                            ),
                            const SizedBox(height: 14),

                            // ── حقل الرمز ──────────────────
                            AnimatedWidgets.slideIn(
                              direction: SlideDirection.right,
                              delay: const Duration(milliseconds: 500),
                              child: _buildPasswordField(),
                            ),
                            const SizedBox(height: 8),

                            // ── نسيت الرمز ─────────────────
                            AnimatedWidgets.fadeIn(
                              delay: const Duration(milliseconds: 600),
                              child: _buildForgotPassword(),
                            ),
                            const SizedBox(height: 24),

                            // ── زر الدخول ──────────────────
                            AnimatedWidgets.scaleIn(
                              delay: const Duration(milliseconds: 700),
                              child: _buildLoginButton(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── footer ─────────────────────────────
                    Text(
                      'منصة رُشد التعليمية الذكية© 2026',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.12),
          ),
        ),
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/roshd.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── حقل البريد الإلكتروني ────────────────────────────────
  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0), width: 1.2),
      ),
      child: TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: controller.validateEmail,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1A2B4A),
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          labelText: 'البريد الإلكتروني',
          labelStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Color(0xFF0D6EBD),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ── حقل الرمز ────────────────────────────────────────────
  Widget _buildPasswordField() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF0), width: 1.2),
        ),
        child: TextFormField(
          controller: controller.passwordController,
          obscureText: controller.obscurePassword.value,
          validator: controller.validatePassword,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A2B4A),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'الرمز',
            hintText: 'أدخل رمزك المكون من 4 أرقام',
            labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFF0D6EBD),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF0D6EBD),
                size: 20,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
      ),
    );
  }

  // ── نسيت الرمز ───────────────────────────────────────────
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          Get.snackbar(
            'قريباً',
            'ميزة استعادة كلمة المرور قريباً',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'نسيت الرمز؟',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF0D6EBD),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── زر تسجيل الدخول ─────────────────────────────────────
  Widget _buildLoginButton() {
    return Obx(
      () => AnimatedWidgets.bounceButton(
        onTap: controller.isLoading.value ? () {} : controller.login,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D6EBD), Color(0xFF0A9396)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D6EBD).withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: controller.isLoading.value
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── موجة فاصلة ───────────────────────────────────────────
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
