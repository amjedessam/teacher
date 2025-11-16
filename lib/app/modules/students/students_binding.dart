import 'package:get/get.dart';
import 'students_controller.dart';

class StudentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentsController>(() => StudentsController());
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:teacher/app/core/widgets/animated_widgets.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import 'login_controller.dart';

// class LoginView extends GetView<LoginController> {
//   const LoginView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color.fromARGB(255, 255, 255, 255),
//         // decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Form(
//               key: controller.formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 60),
//                   AnimatedWidgets.pulse(
//                     child: AnimatedWidgets.scaleIn(
//                       delay: const Duration(milliseconds: 200),
//                       child: Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(
//                           gradient: AppColors.primaryGradient,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.shadowNeon,
//                               blurRadius: 25,
//                               offset: const Offset(0, 15),
//                             ),
//                           ],
//                         ),
//                         child: const Center(
//                           child: Text('👨‍🏫', style: TextStyle(fontSize: 60)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   AnimatedWidgets.fadeIn(
//                     delay: const Duration(milliseconds: 400),
//                     child: AnimatedWidgets.slideIn(
//                       direction: SlideDirection.top,
//                       child: Text(
//                         'مرحباً بك في عالم التعلم!',
//                         style: AppTextStyles.displayMedium.copyWith(
//                           color: Color(0xFF493Ad5),
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   AnimatedWidgets.fadeIn(
//                     delay: const Duration(milliseconds: 500),
//                     child: Text(
//                       'سجل دخولك وابدأ رحلتك التعليمية',
//                       style: AppTextStyles.bodyLarge.copyWith(
//                         color: Color(0xFF493Ad5),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 60),
//                   AnimatedWidgets.slideIn(
//                     direction: SlideDirection.left,
//                     delay: const Duration(milliseconds: 600),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 255, 255, 255),
//                         // borderRadius: BorderRadius.circular(16),
//                         // boxShadow: [
//                         //   BoxShadow(
//                         //     color: AppColors.shadowLight,
//                         //     blurRadius: 10,
//                         //     offset: const Offset(0, 5),
//                         //   ),
//                         // ],
//                       ),
//                       child: TextFormField(
//                         controller: controller.emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: controller.validateEmail,
//                         decoration: InputDecoration(
//                           labelStyle: TextStyle(color: Color(0xFF493Ad5)),
//                           hintStyle: TextStyle(color: Color(0xFF493Ad5)),
//                           labelText: 'البريد الإلكتروني',
//                           hintText: 'name@school.com',
//                           prefixIcon: Icon(
//                             Icons.email_outlined,
//                             color: Color(0xFF493Ad5),
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.all(16),
//                           enabledBorder: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   AnimatedWidgets.slideIn(
//                     direction: SlideDirection.right,
//                     delay: const Duration(milliseconds: 700),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.surface,
//                         //   borderRadius: BorderRadius.circular(16),
//                         //   boxShadow: [
//                         //     BoxShadow(
//                         //       color: AppColors.shadowLight,
//                         //       blurRadius: 10,
//                         //       offset: const Offset(0, 5),
//                         //     ),
//                         //   ],
//                         // ),
//                       ),

//                       child: Obx(
//                         () => TextFormField(
//                           controller: controller.passwordController,
//                           obscureText: !controller.isPasswordVisible.value,
//                           validator: controller.validatePassword,
//                           decoration: InputDecoration(
//                             labelStyle: TextStyle(color: Color(0xFF493Ad5)),
//                             hintStyle: TextStyle(color: Color(0xFF493Ad5)),

//                             focusColor: Color(0xFF493Ad5),
//                             labelText: 'كلمة المرور',
//                             hintText: '••••••',
//                             prefixIcon: Icon(
//                               Icons.lock_outline,
//                               color: Color(0xFF493Ad5),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 controller.isPasswordVisible.value
//                                     ? Icons.visibility_outlined
//                                     : Icons.visibility_off_outlined,
//                                 color: AppColors.primary,
//                               ),
//                               onPressed: controller.togglePasswordVisibility,
//                             ),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.all(16),
//                             enabledBorder: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   AnimatedWidgets.fadeIn(
//                     delay: const Duration(milliseconds: 800),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: TextButton(
//                         onPressed: () {
//                           Get.snackbar(
//                             'قريباً',
//                             'ميزة استعادة كلمة المرور قريباً',
//                             snackPosition: SnackPosition.BOTTOM,
//                           );
//                         },
//                         child: Text(
//                           'نسيت كلمة المرور؟',
//                           style: AppTextStyles.bodyMedium.copyWith(
//                             color: Color(0xFF493Ad5),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'ليس لديك حساب؟',
//                         style: TextStyle(color: AppColors.textSecondary),
//                       ),
//                       TextButton(
//                         onPressed: controller.goToRegister,
//                         child: const Text('سجل الآن'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//                   AnimatedWidgets.scaleIn(
//                     delay: const Duration(milliseconds: 900),
//                     child: AnimatedWidgets.bounceButton(
//                       onTap: controller.isLoading.value
//                           ? () {}
//                           : () => controller.login(),
//                       child: Container(
//                         height: 60,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           gradient: AppColors.primaryGradient,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.shadowNeon,
//                               blurRadius: 15,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Obx(
//                           () => ElevatedButton(
//                             onPressed: controller.isLoading.value
//                                 ? null
//                                 : () => controller.login(),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//                             child: controller.isLoading.value
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : Text(
//                                     'تسجيل الدخول',
//                                     style: AppTextStyles.button,
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
