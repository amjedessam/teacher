// import 'package:get/get.dart';
// import '../../routes/app_routes.dart';

// class SplashController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     _navigateToLogin();
//   }

//   void _navigateToLogin() {
//     Future.delayed(const Duration(seconds: 3), () {
//       Get.offNamed(AppRoutes.login);
//     });
//   }
// }

import 'package:get/get.dart';
import '../../data/services/auth_service.dart'; // تم تغيير الاستيراد إلى AuthService
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find(); // استخدام AuthService

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  /// فحص حالة تسجيل الدخول والتوجيه المناسب
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    if (_authService.isAuthenticated.value) {
      // التحقق من حالة المصادقة
      // المستخدم مسجل دخوله - الانتقال للرئيسية
      Get.offNamed(AppRoutes.mainNavigation);
    } else {
      // المستخدم غير مسجل - الانتقال لتسجيل الدخول
      Get.offNamed(AppRoutes.login);
    }
  }
}
