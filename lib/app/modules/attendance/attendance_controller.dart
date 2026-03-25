import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/student_model.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final sectionId = 0.obs;
  final sectionName = ''.obs;
  final students = <StudentModel>[].obs;
  final selectedDate = Rx<DateTime>(DateTime.now());
  final statusByStudentId = <String, String>{}.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      sectionId.value = args['sectionId'] as int? ?? 0;
      sectionName.value = args['sectionName'] as String? ?? '';
      final list = args['students'] as List<dynamic>?;
      if (list != null) {
        students.value = list.cast<StudentModel>();
        for (final s in students) {
          statusByStudentId[s.id] = 'present';
        }
      }
    }
    loadExistingAttendance();
  }

  Future<void> loadExistingAttendance() async {
    if (sectionId.value <= 0) return;
    isLoading.value = true;
    try {
      final existing = await _attendanceRepo.getAttendanceForDate(
        sectionId: sectionId.value,
        date: selectedDate.value,
      );
      for (final r in existing) {
        statusByStudentId['${r.studentId}'] = r.status;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    loadExistingAttendance();
  }

  void setStatus(String studentId, String status) {
    statusByStudentId[studentId] = status;
  }

  Future<void> submit() async {
    if (sectionId.value <= 0 || students.isEmpty) return;
    final teacherId = int.tryParse(_authService.currentUser.value?.id ?? '');
    if (teacherId == null) {
      Get.snackbar('خطأ', 'يجب تسجيل الدخول');
      return;
    }
    isSaving.value = true;
    try {
      final records = students.map((s) {
        return AttendanceRecord(
          studentId: int.parse(s.id),
          studentName: s.name,
          status: statusByStudentId[s.id] ?? 'present',
        );
      }).toList();
      final ok = await _attendanceRepo.submitAttendance(
        sectionId: sectionId.value,
        date: selectedDate.value,
        sectionName: sectionName.value,
        teacherId: teacherId,
        records: records,
      );
      if (ok) {
        Get.snackbar('تم', 'تم تسجيل الحضور بنجاح', backgroundColor: Colors.green.shade100);
        Get.back();
      } else {
        Get.snackbar('خطأ', 'فشل حفظ الحضور', backgroundColor: Colors.red.shade100);
      }
    } finally {
      isSaving.value = false;
    }
  }
}
