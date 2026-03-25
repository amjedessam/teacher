import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await _authService.ensureSessionLoaded();
    await Future.delayed(const Duration(milliseconds: 800));

    if (_authService.isAuthenticated.value) {
      Get.offNamed(AppRoutes.mainNavigation);
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }
}
