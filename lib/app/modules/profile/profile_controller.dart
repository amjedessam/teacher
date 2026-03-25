import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/auth_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/models/teacher_model.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find();
  final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
  SupabaseClient get _client => Supabase.instance.client;
  final teacher = Rxn<TeacherModel>();

  @override
  void onInit() {
    super.onInit();
    ever(_authService.currentUser, (user) {
      teacher.value = user;
      _loadStats();
    });
    loadProfile();
  }

  void loadProfile() {
    teacher.value = _authService.currentUser.value;
    _loadStats();
  }

  Future<void> _loadStats() async {
    if (teacher.value == null) return;
    try {
      // جلب الفصول والطلاب
      final classes = await _classesRepo.getAssignedClasses();
      final totalClasses = classes.length;
      final totalStudents = classes.fold<int>(0, (sum, c) => sum + c.totalStudents);

      // جلب المعدل من RPC
      double avgScore = 0;
      try {
        final teacherId = int.parse(teacher.value!.id);
        final res = await _client.rpc(
          'get_teacher_dashboard_stats',
          params: {'p_teacher_id': teacherId},
        );
        if (res != null) {
          final data = Map<String, dynamic>.from(res);
          avgScore = (data['avg_score'] as num?)?.toDouble() ?? 0;
        }
      } catch (e) {
        debugPrint('_loadStats RPC error: $e');
      }

      // تحديث بيانات المعلم
      teacher.value = teacher.value!.copyWith(
        totalStudents: totalStudents,
        totalClasses: totalClasses,
        averageScore: avgScore,
      );
    } catch (e) {
      debugPrint('_loadStats error: $e');
    }
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
