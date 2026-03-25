import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/class_model.dart';
import '../models/student_model.dart';

/// جلب فصول المعلم المعين لها والطلاب حسب القسم من Supabase (RLS + JWT).
class ClassesRepository {
  SupabaseClient get _client => Supabase.instance.client;

  /// فصول المعلم من RPC (بحسب JWT).
  Future<List<ClassModel>> getAssignedClasses() async {
    try {
      final res = await _client.rpc('get_teacher_classes');
      if (res == null) return [];
      final list = res is List ? res : [res];
      return list
          .map<ClassModel>((e) =>
              ClassModel.fromTeacherClassRow(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// طلاب قسم معين (RLS تسمح فقط بالأقسام المعين لها المعلم).
  Future<List<StudentModel>> getStudentsBySection({
    required int sectionId,
    String? sectionName,
  }) async {
    try {
      final res = await _client
          .from('students')
          .select('id, student_code, full_name, email, section_id, profile_image_url, last_login_at')
          .eq('section_id', sectionId);
      if (res == null) return [];
      final list = res is List ? res : [res];
      final name = sectionName ?? '';
      return list
          .map<StudentModel>((e) => StudentModel.fromStudentRow(
                Map<String, dynamic>.from(e as Map),
                className: name,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
