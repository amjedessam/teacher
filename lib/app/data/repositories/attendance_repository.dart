import 'package:supabase_flutter/supabase_flutter.dart';

/// تسجيل الحضور اليومي في جدول attendance (RLS: المعلم يدرج فقط لأقسامه).
class AttendanceRepository {
  SupabaseClient get _client => Supabase.instance.client;

  /// تسجيل حضور مجموعة طلاب ليوم معين. marked_by يُحدد من RLS أو نمرره من المعلم الحالي.
  Future<bool> submitAttendance({
    required int sectionId,
    required DateTime date,
    required String sectionName,
    required int teacherId,
    required List<AttendanceRecord> records,
  }) async {
    if (records.isEmpty) return true;
    try {
      final dateStr = DateTime(date.year, date.month, date.day).toIso8601String().split('T').first;
      for (final r in records) {
        await _client.from('attendance').insert({
          'student_id': r.studentId,
          'section_id': sectionId,
          'attendance_date': dateStr,
          'status': r.status,
          'notes': r.notes,
          'marked_by': teacherId,
          'student_name_cache': r.studentName,
          'section_name_cache': sectionName,
        });
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// جلب الحضور المسجّل سابقاً لليوم والقسم (للتعديل أو العرض).
  Future<List<AttendanceRecord>> getAttendanceForDate({
    required int sectionId,
    required DateTime date,
  }) async {
    try {
      final dateStr = DateTime(date.year, date.month, date.day).toIso8601String().split('T').first;
      final res = await _client
          .from('attendance')
          .select('student_id, status, notes, student_name_cache')
          .eq('section_id', sectionId)
          .eq('attendance_date', dateStr);
      if (res == null) return [];
      final list = res is List ? res : [res];
      return list
          .map((e) {
            final m = Map<String, dynamic>.from(e as Map);
            return AttendanceRecord(
              studentId: m['student_id'] as int,
              studentName: m['student_name_cache']?.toString(),
              status: m['status']?.toString() ?? 'present',
              notes: m['notes']?.toString(),
            );
          })
          .toList();
    } catch (_) {
      return [];
    }
  }
}

class AttendanceRecord {
  final int studentId;
  final String? studentName;
  final String status;
  final String? notes;

  AttendanceRecord({
    required this.studentId,
    this.studentName,
    required this.status,
    this.notes,
  });
}
