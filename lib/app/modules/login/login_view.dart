// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/theme/app_text_styles.dart';
// import 'login_controller.dart';

// class LoginView extends GetView<LoginController> {
//   const LoginView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 40),

//                 // Logo
//                 Center(
//                   child: Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       gradient: AppColors.primaryGradient,
//                       borderRadius: BorderRadius.circular(25),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primary.withOpacity(0.3),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text('👨‍🏫', style: TextStyle(fontSize: 50)),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Welcome Text
//                 Text(
//                   'مرحباً بك',
//                   style: AppTextStyles.displayMedium,
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 8),

//                 Text(
//                   'سجل دخولك للمتابعة',
//                   style: AppTextStyles.bodyLarge.copyWith(
//                     color: AppColors.textSecondary,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 48),

//                 // Email Field
//                 TextFormField(
//                   controller: controller.emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: controller.validateEmail,
//                   decoration: InputDecoration(
//                     labelText: 'البريد الإلكتروني',
//                     hintText: 'name@school.com',
//                     prefixIcon: const Icon(Icons.email_outlined),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Password Field
//                 Obx(
//                   () => TextFormField(
//                     controller: controller.passwordController,
//                     obscureText: !controller.isPasswordVisible.value,
//                     validator: controller.validatePassword,
//                     decoration: InputDecoration(
//                       labelText: 'كلمة المرور',
//                       hintText: '••••••',
//                       prefixIcon: const Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           controller.isPasswordVisible.value
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                         ),
//                         onPressed: controller.togglePasswordVisibility,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Forgot Password
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: () {
//                       Get.snackbar(
//                         'قريباً',
//                         'ميزة استعادة كلمة المرور قريباً',
//                         snackPosition: SnackPosition.BOTTOM,
//                       );
//                     },
//                     child: Text(
//                       'نسيت كلمة المرور؟',
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Login Button
//                 Obx(
//                   () => SizedBox(
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: controller.isLoading.value
//                           ? null
//                           : controller.login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: controller.isLoading.value
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : Text('تسجيل الدخول', style: AppTextStyles.button),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Demo Credentials Info
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.info.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: AppColors.info.withOpacity(0.3)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.info_outline,
//                             color: AppColors.info,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'بيانات تجريبية',
//                             style: AppTextStyles.labelBold.copyWith(
//                               color: AppColors.info,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'يمكنك استخدام أي بريد إلكتروني وكلمة مرور للتجربة',
//                         style: AppTextStyles.bodySmall.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// التصميم الجديد لصفحة تسجيل الدخول

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // ✨ Logo with Animation
                AnimatedWidgets.scaleIn(
                  duration: const Duration(milliseconds: 800),
                  child: _buildLogo(),
                ),

                const SizedBox(height: 40),

                // ✨ Title with Fade
                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: _buildTitle(),
                ),

                const SizedBox(height: 40),

                // ✨ Email Field with Slide
                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 400),
                  child: _buildEmailField(),
                ),

                const SizedBox(height: 16),

                // ✨ Password Field with Slide
                AnimatedWidgets.slideIn(
                  direction: SlideDirection.right,
                  delay: const Duration(milliseconds: 500),
                  child: _buildPasswordField(),
                ),

                const SizedBox(height: 12),

                // ✨ Remember Me & Forgot Password
                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 600),
                  child: _buildRememberAndForgot(),
                ),

                const SizedBox(height: 32),

                // ✨ Login Button
                AnimatedWidgets.scaleIn(
                  delay: const Duration(milliseconds: 700),
                  child: _buildLoginButton(),
                ),

                const SizedBox(height: 24),

                // ✨ Divider
                AnimatedWidgets.fadeIn(
                  delay: const Duration(milliseconds: 800),
                  child: _buildDivider(),
                ),

                const SizedBox(height: 24),

                // ✨ Sign Up Link ⭐ جديد
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
          'تطبيق المعلم',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً بعودتك! 👋',
          style: AppTextStyles.h1.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل دخولك للمتابعة',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('البريد الإلكتروني', style: AppTextStyles.labelBold),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: controller.validateEmail,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'example@domain.com',
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primary,
            ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('كلمة المرور', style: AppTextStyles.labelBold),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            validator: controller.validatePassword,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.primary,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => AnimatedWidgets.bounceButton(
            onTap: () =>
                controller.toggleRememberMe(!controller.rememberMe.value),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.rememberMe.value
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: controller.rememberMe.value
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: controller.rememberMe.value
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
                const SizedBox(width: 8),
                Text('تذكرني', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'نسيت كلمة المرور؟',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
                    const Icon(Icons.login, color: Colors.white),
                    const SizedBox(width: 12),
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أو',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  // ✨ Sign Up Link - جديد
  Widget _buildSignUpLink() {
    return Center(
      child: AnimatedWidgets.bounceButton(
        onTap: () => Get.toNamed(AppRoutes.signup),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_add_alt_1,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text.rich(
                TextSpan(
                  text: 'ليس لديك حساب؟ ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'سجل الآن',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
