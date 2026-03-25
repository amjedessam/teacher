import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/student_model.dart';

class StudentNoteController extends GetxController {
  SupabaseClient get _client => Supabase.instance.client;

  // ── بيانات الطالب ─────────────────────────────────────────
  late final StudentModel student;

  // ── Form ──────────────────────────────────────────────────
  final noteController = TextEditingController();
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    // استقبال بيانات الطالب من arguments
    final args = Get.arguments;
    if (args is Map && args['student'] != null) {
      student = args['student'] as StudentModel;
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }

  // ── حفظ الملاحظة في daily_summaries ──────────────────────
  Future<void> saveNote() async {
    final note = noteController.text.trim();
    if (note.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى كتابة الملاحظة أولاً',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;
    try {
      final teacherId = int.parse(
        Get.find<AuthService>().currentUser.value!.id,
      );
      final studentId = int.tryParse(student.id);
      if (studentId == null) throw Exception('معرف الطالب غير صالح');

      final today = DateTime.now().toIso8601String().split('T').first;

      // UPSERT — يحدّث إذا موجود أو ينشئ جديد
      await _client.from('daily_summaries').upsert({
        'student_id': studentId,
        'summary_date': today,
        'teacher_note': note,
        'created_by_teacher_id': teacherId,
      }, onConflict: 'student_id,summary_date');

      Get.back();
      Get.snackbar(
        'تم الإرسال ✅',
        'أُرسلت الملاحظة لولي أمر ${student.name}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('saveNote error: $e');
      Get.snackbar(
        'خطأ',
        'فشل إرسال الملاحظة',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
