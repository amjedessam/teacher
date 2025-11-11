import 'package:get/get.dart';
import '../models/teacher_model.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final StorageService _storageService = Get.find();

  // المستخدم الحالي (Reactive)
  final Rx<TeacherModel?> currentUser = Rx<TeacherModel?>(null);
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  /// تحميل المستخدم الحالي من التخزين
  void _loadCurrentUser() {
    if (_storageService.isLoggedIn) {
      currentUser.value = _storageService.getCurrentUser();
      isAuthenticated.value = currentUser.value != null;
    }
  }

  /// تسجيل الدخول
  Future<LoginResult> login(String email, String password) async {
    try {
      // التحقق من صحة البيانات
      final user = _storageService.validateCredentials(email, password);

      if (user == null) {
        return LoginResult(
          success: false,
          message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      }

      // حفظ الجلسة
      await _storageService.saveCurrentUser(user);
      currentUser.value = user;
      isAuthenticated.value = true;

      return LoginResult(
        success: true,
        message: 'تم تسجيل الدخول بنجاح',
        user: user,
      );
    } catch (e) {
      return LoginResult(success: false, message: 'حدث خطأ أثناء تسجيل الدخول');
    }
  }

  /// التسجيل
  Future<SignupResult> signup({
    required TeacherModel teacher,
    required String password,
  }) async {
    try {
      // حفظ المستخدم الجديد
      final saved = await _storageService.saveUser(teacher, password);

      if (!saved) {
        return SignupResult(
          success: false,
          message: 'البريد الإلكتروني مستخدم مسبقاً',
        );
      }

      // تسجيل دخول تلقائي
      await _storageService.saveCurrentUser(teacher);
      currentUser.value = teacher;
      isAuthenticated.value = true;

      return SignupResult(
        success: true,
        message: 'تم إنشاء الحساب بنجاح',
        user: teacher,
      );
    } catch (e) {
      return SignupResult(
        success: false,
        message: 'حدث خطأ أثناء إنشاء الحساب',
      );
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    await _storageService.logout();
    currentUser.value = null;
    isAuthenticated.value = false;
  }

  /// تحديث معلومات المستخدم
  Future<bool> updateUser(TeacherModel updatedUser) async {
    final result = await _storageService.updateCurrentUser(updatedUser);
    if (result) {
      currentUser.value = updatedUser;
    }
    return result;
  }
}

// ==================== Result Classes ====================

class LoginResult {
  final bool success;
  final String message;
  final TeacherModel? user;

  LoginResult({required this.success, required this.message, this.user});
}

class SignupResult {
  final bool success;
  final String message;
  final TeacherModel? user;

  SignupResult({required this.success, required this.message, this.user});
}
