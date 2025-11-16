import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result.success) {
        Get.snackbar(
          'مرحباً! ',
          'تم تسجيل الدخول بنجاح',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.mainNavigation);
      } else {
        Get.snackbar(
          'فشل تسجيل الدخول',
          result.message,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline, color: Colors.red),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع. حاول مرة أخرى',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset, color: Colors.blue),
            SizedBox(width: 12),
            Text('إعادة تعيين كلمة المرور'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أدخل بريدك الإلكتروني لإرسال رابط إعادة تعيين كلمة المرور',
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'البريد الإلكتروني',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'تم الإرسال',
                'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
                backgroundColor: Colors.blue.shade100,
                colorText: Colors.blue.shade900,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void goToSignup() {
    Get.toNamed(AppRoutes.signup);
  }
}
