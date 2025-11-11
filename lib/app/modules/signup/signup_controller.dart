// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../data/models/teacher_model.dart';
// import '../../routes/app_routes.dart';

// class SignupController extends GetxController {
//   // Form Controllers
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final schoolController = TextEditingController();

//   // Form Key
//   final formKey = GlobalKey<FormState>();

//   // Observables
//   final isLoading = false.obs;
//   final obscurePassword = true.obs;
//   final obscureConfirmPassword = true.obs;
//   final acceptTerms = false.obs;
//   final selectedSubjects = <String>[].obs;

//   // Available Subjects
//   final availableSubjects = [
//     'الرياضيات',
//     'العلوم',
//     'اللغة العربية',
//     'اللغة الإنجليزية',
//     'الفيزياء',
//     'الكيمياء',
//     'الأحياء',
//     'التاريخ',
//     'الجغرافيا',
//     'الحاسوب',
//   ];

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     schoolController.dispose();
//     super.onClose();
//   }

//   // Toggle Password Visibility
//   void togglePasswordVisibility() =>
//       obscurePassword.value = !obscurePassword.value;
//   void toggleConfirmPasswordVisibility() =>
//       obscureConfirmPassword.value = !obscureConfirmPassword.value;

//   // Toggle Terms Acceptance
//   void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

//   // Toggle Subject Selection
//   void toggleSubject(String subject) {
//     if (selectedSubjects.contains(subject)) {
//       selectedSubjects.remove(subject);
//     } else {
//       selectedSubjects.add(subject);
//     }
//   }

//   // Validators
//   String? validateName(String? value) {
//     if (value == null || value.isEmpty) return 'الرجاء إدخال الاسم الكامل';
//     if (value.length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
//     return null;
//   }

//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'الرجاء إدخال البريد الإلكتروني';
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return 'البريد الإلكتروني غير صحيح';
//     return null;
//   }

//   String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) return 'الرجاء إدخال رقم الهاتف';
//     if (value.length < 10) return 'رقم الهاتف غير صحيح';
//     return null;
//   }

//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) return 'الرجاء إدخال كلمة المرور';
//     if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//     return null;
//   }

//   String? validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) return 'الرجاء تأكيد كلمة المرور';
//     if (value != passwordController.text) return 'كلمات المرور غير متطابقة';
//     return null;
//   }

//   String? validateSchool(String? value) {
//     if (value == null || value.isEmpty) return 'الرجاء إدخال اسم المدرسة';
//     return null;
//   }

//   // Sign Up
//   Future<void> signUp() async {
//     if (!formKey.currentState!.validate()) return;

//     if (selectedSubjects.isEmpty) {
//       Get.snackbar(
//         'خطأ',
//         'الرجاء اختيار مادة واحدة على الأقل',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//         borderRadius: 12,
//         icon: const Icon(Icons.error_outline, color: Colors.red),
//       );
//       return;
//     }

//     if (!acceptTerms.value) {
//       Get.snackbar(
//         'خطأ',
//         'الرجاء الموافقة على الشروط والأحكام',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//         borderRadius: 12,
//         icon: const Icon(Icons.error_outline, color: Colors.red),
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));

//       // إنشاء بيانات المعلم
//       final teacher = TeacherModel(
//         id: 'teacher_${DateTime.now().millisecondsSinceEpoch}',
//         name: nameController.text,
//         email: emailController.text,
//         phone: phoneController.text,
//         subjects: selectedSubjects.toList(),
//         employeeId: 'EMP${DateTime.now().millisecondsSinceEpoch}',
//         school: schoolController.text,
//         profileImage: '',
//         totalStudents: 0,
//         totalClasses: 0,
//         averageScore: 0.0,
//         joinedDate: DateTime.now(),
//       );

//       // حفظ البيانات في SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_name', teacher.name);
//       await prefs.setString('user_email', teacher.email);
//       await prefs.setString('user_phone', teacher.phone);
//       await prefs.setStringList('user_subjects', teacher.subjects);
//       await prefs.setString('user_employee_id', teacher.employeeId);
//       await prefs.setString('user_school', teacher.school ?? '');

//       // حفظ كامل بيانات المعلم بصيغة JSON صحيحة
//       await prefs.setString('teacher_data', jsonEncode(teacher.toJson()));

//       // رسالة نجاح
//       Get.snackbar(
//         'نجح التسجيل! 🎉',
//         'تم إنشاء حسابك بنجاح',
//         backgroundColor: Colors.green.shade100,
//         colorText: Colors.green.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//         borderRadius: 12,
//         icon: const Icon(Icons.check_circle_outline, color: Colors.green),
//         duration: const Duration(seconds: 3),
//       );

//       // الانتقال مباشرة إلى الشاشة الرئيسية
//       await Future.delayed(const Duration(milliseconds: 500));
//       Get.offAllNamed(AppRoutes.mainNavigation);
//     } catch (e) {
//       Get.snackbar(
//         'خطأ',
//         'حدث خطأ أثناء التسجيل: ${e.toString()}',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//         borderRadius: 12,
//         icon: const Icon(Icons.error_outline, color: Colors.red),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Navigate to Login
//   void goToLogin() {
//     Get.back(); // أو Get.toNamed(AppRoutes.login) إذا أردت الانتقال إلى صفحة تسجيل الدخول مباشرة
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../data/models/user_model.dart'; // تم التغيير إلى UserModel
// import '../../routes/app_routes.dart';
// import '../../data/services/storage_service.dart'; // استيراد الخدمة

// class SignupController extends GetxController {
//   // حقن StorageService
//   final StorageService _storageService = Get.find<StorageService>();

//   // Form Controllers
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   // Form Key
//   final formKey = GlobalKey<FormState>();

//   // Observable Variables
//   final isLoading = false.obs;
//   final obscurePassword = true.obs;
//   final obscureConfirmPassword = true.obs;
//   final acceptTerms = false.obs;

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   void toggleConfirmPasswordVisibility() {
//     obscureConfirmPassword.value = !obscureConfirmPassword.value;
//   }

//   void toggleTerms(bool? value) {
//     acceptTerms.value = value ?? false;
//   }

//   // Validation
//   String? validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'الرجاء إدخال الاسم الكامل';
//     }
//     return null;
//   }

//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'الرجاء إدخال البريد الإلكتروني';
//     }
//     if (!GetUtils.isEmail(value)) {
//       return 'البريد الإلكتروني غير صحيح';
//     }
//     return null;
//   }

//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'الرجاء إدخال كلمة المرور';
//     }
//     if (value.length < 6) {
//       return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//     }
//     return null;
//   }

//   String? validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'الرجاء تأكيد كلمة المرور';
//     }
//     if (value != passwordController.text) {
//       return 'كلمات المرور غير متطابقة';
//     }
//     return null;
//   }

//   Future<void> signUp() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     if (!acceptTerms.value) {
//       Get.snackbar(
//         'خطأ',
//         'الرجاء الموافقة على الشروط والأحكام',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;
//       await Future.delayed(const Duration(seconds: 1));

//       // إنشاء مستخدم جديد
//       final newUser = UserModel(
//         // ملاحظة: استخدام كلمة المرور كـ ID هو لأغراض العرض فقط وغير آمن
//         id: passwordController.text,
//         name: nameController.text,
//         email: emailController.text,
//         createdAt: DateTime.now(),
//       );

//       // حفظ المستخدم الجديد في التخزين
//       await _storageService.saveUser(newUser);
//       // تحديد أن المستخدم قام بتسجيل الدخول
//       await _storageService.setLoggedIn(true);

//       isLoading.value = false;

//       Get.snackbar(
//         'نجح التسجيل! 🎉',
//         'تم إنشاء حسابك بنجاح، أهلاً بك!',
//         backgroundColor: Colors.green.shade100,
//         colorText: Colors.green.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//       );

//       // الانتقال مباشرة إلى الواجهة الرئيسية
//       Get.offAllNamed(AppRoutes.mainNavigation);
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar(
//         'خطأ',
//         'حدث خطأ أثناء التسجيل: ${e.toString()}',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//       );
//     }
//   }

//   void goToLogin() {
//     Get.back();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find();

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final schoolController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observables
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final acceptTerms = false.obs;
  final selectedSubjects = <String>[].obs;

  // Available Subjects
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

  // Toggle Methods
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

  // Validators
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

  // ==================== التسجيل الحقيقي ====================

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

      // إنشاء كائن المعلم
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

      // التسجيل عبر AuthService
      final result = await _authService.signup(
        teacher: teacher,
        password: passwordController.text,
      );

      if (result.success) {
        // رسالة نجاح
        Get.snackbar(
          'نجح التسجيل! 🎉',
          'تم إنشاء حسابك بنجاح',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          duration: const Duration(seconds: 2),
        );

        // الانتقال إلى الشاشة الرئيسية (تسجيل دخول تلقائي)
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
