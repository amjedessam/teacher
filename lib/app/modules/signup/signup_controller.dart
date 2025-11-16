import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final schoolController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final acceptTerms = false.obs;
  final selectedSubjects = <String>[].obs;

  final availableSubjects = [
    'الرياضيات',
    'العلوم',
    'اللغة العربية',
    'اللغة الإنجليزية',
    'الفيزياء',
    'الكيمياء',
    'الأحياء',
    'التاريخ',
    'الجغرافيا',
    'الحاسوب',
  ];

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    schoolController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;
  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

  void toggleSubject(String subject) {
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      selectedSubjects.add(subject);
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال الاسم الكامل';
    if (value.length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'البريد الإلكتروني غير صحيح';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال رقم الهاتف';
    if (value.length < 10) return 'رقم الهاتف غير صحيح';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء تأكيد كلمة المرور';
    if (value != passwordController.text) return 'كلمات المرور غير متطابقة';
    return null;
  }

  String? validateSchool(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال اسم المدرسة';
    return null;
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedSubjects.isEmpty) {
      _showError('الرجاء اختيار مادة واحدة على الأقل');
      return;
    }

    if (!acceptTerms.value) {
      _showError('الرجاء الموافقة على الشروط والأحكام');
      return;
    }

    try {
      isLoading.value = true;

      final teacher = TeacherModel(
        id: 'teacher_${DateTime.now().millisecondsSinceEpoch}',
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subjects: selectedSubjects.toList(),
        employeeId: 'EMP${DateTime.now().millisecondsSinceEpoch}',
        school: schoolController.text.trim(),
        profileImage: '👨‍🏫',
        totalStudents: 0,
        totalClasses: 0,
        averageScore: 0.0,
        joinedDate: DateTime.now(),
      );

      final result = await _authService.signup(
        teacher: teacher,
        password: passwordController.text,
      );

      if (result.success) {
        Get.snackbar(
          'نجح التسجيل',
          'تم إنشاء حسابك بنجاح',
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
        _showError(result.message);
      }
    } catch (e) {
      _showError('حدث خطأ غير متوقع. حاول مرة أخرى');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.red),
    );
  }

  void goToLogin() {
    Get.back();
  }
}
