// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../routes/app_routes.dart';

// class LoginController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   final isLoading = false.obs;
//   final isPasswordVisible = false.obs;

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   Future<void> login() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     isLoading.value = true;

//     // Simulate API call
//     await Future.delayed(const Duration(seconds: 2));

//     isLoading.value = false;

//     // Navigate to main navigation
//     Get.offAllNamed(AppRoutes.mainNavigation);

//     Get.snackbar(
//       'تسجيل الدخول',
//       'تم تسجيل الدخول بنجاح',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(16),
//       borderRadius: 12,
//       duration: const Duration(seconds: 2),
//     );
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

// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../data/models/teacher_model.dart';
// import '../../routes/app_routes.dart';

// class LoginController extends GetxController {
//   // Form Controllers

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   // Form Key
//   final formKey = GlobalKey<FormState>();

//   // Observable Variables
//   final isLoading = false.obs;
//   final obscurePassword = true.obs;
//   final rememberMe = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // Check if there's saved credentials
//     _loadSavedCredentials();
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   // Load Saved Credentials (if remember me was checked)
//   void _loadSavedCredentials() {
//     // TODO: Load from secure storage
//     // For now, just demo values
//     // emailController.text = 'teacher@example.com';
//     // passwordController.text = 'password123';
//   }

//   // Toggle Password Visibility
//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   // Toggle Remember Me
//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
//   }

//   // Email Validation
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'الرجاء إدخال البريد الإلكتروني';
//     }

//     // Email regex pattern
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

//     if (!emailRegex.hasMatch(value)) {
//       return 'البريد الإلكتروني غير صحيح';
//     }

//     return null;
//   }

//   // Password Validation
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'الرجاء إدخال كلمة المرور';
//     }

//     if (value.length < 6) {
//       return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//     }

//     return null;
//   }

//   // Login Method
//   Future<void> login() async {
//     // Validate form
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));

//       // TODO: Replace with actual API call
//       /*
//       final response = await authService.login(
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       if (response.success) {
//         // Save token
//         await storage.saveToken(response.token);

//         // Save user data
//         await storage.saveUser(response.user);

//         // Save credentials if remember me is checked
//         if (rememberMe.value) {
//           await storage.saveCredentials(
//             email: emailController.text,
//             password: passwordController.text,
//           );
//         }

//         // Navigate to main
//         Get.offAllNamed(AppRoutes.main);
//       }
//       */

//       // Demo: Accept any credentials for testing
//       final email = emailController.text;
//       final password = passwordController.text;

//       // Demo validation
//       if (email == 'teacher@example.com' && password == 'password') {
//         // Create demo teacher
//         final teacher = TeacherModel(
//           id: 'teacher_123',
//           name: 'أحمد محمد',
//           email: email,
//           phone: '0501234567',
//           subjects: ['الرياضيات', 'الفيزياء'],
//           employeeId: 'EMP12345',
//           school: 'مدرسة النور الثانوية',
//           profileImage: '',
//           totalStudents: 156,
//           totalClasses: 8,
//           averageScore: 87.5,
//           joinedDate: DateTime(2023, 1, 15),
//         );

//         // Save credentials if remember me
//         if (rememberMe.value) {
//           // TODO: Save to secure storage
//           print('Saving credentials...');
//         } // Success message
//         Get.snackbar(
//           'مرحباً! 👋',
//           'تم تسجيل الدخول بنجاح',
//           backgroundColor: Colors.green.shade100,
//           colorText: Colors.green.shade900,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(16),
//           borderRadius: 12,
//           icon: const Icon(Icons.check_circle_outline, color: Colors.green),
//           duration: const Duration(seconds: 2),
//         );

//         // Navigate to main screen
//         await Future.delayed(const Duration(milliseconds: 500));
//         Get.offAllNamed(AppRoutes.mainNavigation);
//       } else {
//         // Invalid credentials
//         Get.snackbar(
//           'خطأ في تسجيل الدخول',
//           'البريد الإلكتروني أو كلمة المرور غير صحيحة',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(16),
//           borderRadius: 12,
//           icon: const Icon(Icons.error_outline, color: Colors.red),
//           duration: const Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       // Error handling
//       Get.snackbar(
//         'خطأ',
//         'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}',
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

//   // Forgot Password
//   void forgotPassword() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.lock_reset, color: Colors.blue),
//             SizedBox(width: 12),
//             Text('إعادة تعيين كلمة المرور'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'أدخل بريدك الإلكتروني لإرسال رابط إعادة تعيين كلمة المرور',
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'البريد الإلكتروني',
//                 prefixIcon: const Icon(Icons.email_outlined),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               Get.snackbar(
//                 'تم الإرسال',
//                 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
//                 backgroundColor: Colors.blue.shade100,
//                 colorText: Colors.blue.shade900,
//                 snackPosition: SnackPosition.BOTTOM,
//                 margin: const EdgeInsets.all(16),
//                 borderRadius: 12,
//                 icon: const Icon(
//                   Icons.check_circle_outline,
//                   color: Colors.blue,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('إرسال'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Navigate to Sign Up
//   void goToSignup() {
//     Get.toNamed(AppRoutes.signup);
//   }

//   // Quick Login (for testing)
//   void quickLogin() {
//     emailController.text = 'teacher@example.com';
//     passwordController.text = 'password';
//     login();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../routes/app_routes.dart';
// import '../../data/services/storage_service.dart'; // استيراد الخدمة

// class LoginController extends GetxController {
//   // حقن StorageService
//   final StorageService _storageService = Get.find<StorageService>();

//   // Form Controllers
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   // Form Key
//   final formKey = GlobalKey<FormState>();

//   // Observable Variables
//   final isLoading = false.obs;
//   final obscurePassword = true.obs;
//   final rememberMe = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // لا تقم بالتحقق هنا، سيتم التعامل معه بواسطة AuthMiddleware
//     _loadSavedCredentials();
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   void _loadSavedCredentials() {
//     // يمكن استخدام هذا لحفظ البريد الإلكتروني إذا تم تحديد "تذكرني"
//   }

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
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

//   Future<void> login() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       isLoading.value = true;
//       await Future.delayed(const Duration(seconds: 1)); // محاكاة للشبكة

//       final storedUser = _storageService.user;
//       final email = emailController.text;
//       final password =
//           passwordController.text; // في تطبيق حقيقي، يجب تشفير كلمة المرور

//       // التحقق مما إذا كان هناك مستخدم مسجل بنفس البريد الإلكتروني
//       if (storedUser != null && storedUser.email == email) {
//         // في هذا المثال، سنعتبر أن `id` هو كلمة المرور (وهو أمر غير آمن إطلاقًا)
//         // في تطبيق حقيقي، يجب مقارنة هاش كلمة المرور
//         if (storedUser.id == password) {
//           await _storageService.setLoggedIn(true);

//           Get.snackbar(
//             'مرحباً بعودتك! 👋',
//             'تم تسجيل الدخول بنجاح',
//             backgroundColor: Colors.green.shade100,
//             colorText: Colors.green.shade900,
//             snackPosition: SnackPosition.BOTTOM,
//             margin: const EdgeInsets.all(16),
//           );

//           Get.offAllNamed(AppRoutes.mainNavigation);
//         } else {
//           // كلمة المرور غير صحيحة
//           Get.snackbar(
//             'خطأ في تسجيل الدخول',
//             'كلمة المرور غير صحيحة.',
//             backgroundColor: Colors.red.shade100,
//             colorText: Colors.red.shade900,
//             snackPosition: SnackPosition.BOTTOM,
//             margin: const EdgeInsets.all(16),
//           );
//         }
//       } else {
//         // البريد الإلكتروني غير موجود
//         Get.snackbar(
//           'خطأ في تسجيل الدخول',
//           'لم يتم العثور على حساب بهذا البريد الإلكتروني. الرجاء التسجيل أولاً.',
//           backgroundColor: Colors.red.shade100,
//           colorText: Colors.red.shade900,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: const EdgeInsets.all(16),
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'خطأ',
//         'حدث خطأ غير متوقع: ${e.toString()}',
//         backgroundColor: Colors.red.shade100,
//         colorText: Colors.red.shade900,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(16),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void goToSignup() {
//     Get.toNamed(AppRoutes.signup);
//   }

//   // دالة تسجيل الدخول السريع أصبحت غير ضرورية
//   void quickLogin() {}
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable Variables
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle Remember Me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Email Validation
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

  // Password Validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  // ==================== تسجيل الدخول الحقيقي ====================

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
        // رسالة نجاح
        Get.snackbar(
          'مرحباً! 👋',
          'تم تسجيل الدخول بنجاح',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          duration: const Duration(seconds: 2),
        );

        // الانتقال إلى الشاشة الرئيسية
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.mainNavigation);
      } else {
        // رسالة خطأ واضحة
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

  // Forgot Password
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

  // Navigate to Sign Up
  void goToSignup() {
    Get.toNamed(AppRoutes.signup);
  }
}
