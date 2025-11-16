import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/teacher_model.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find();
  final teacher = Rxn<TeacherModel>();

  @override
  void onInit() {
    super.onInit();
    ever(_authService.currentUser, (user) {
      teacher.value = user;
    });
    loadProfile();
  }

  void loadProfile() {
    teacher.value = _authService.currentUser.value;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              await _authService.logout();

              Get.snackbar(
                'تم بنجاح',
                'تم تسجيل الخروج بنجاح',
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade900,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
              );

              Get.offAllNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile(TeacherModel updatedTeacher) async {
    final result = await _authService.updateUser(updatedTeacher);

    if (result) {
      teacher.value = updatedTeacher;
      Get.snackbar(
        'تم التحديث',
        'تم تحديث معلوماتك بنجاح',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'خطأ',
        'فشل تحديث المعلومات',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
