import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/models/student_model.dart';
import '../../data/models/class_model.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class StudentsController extends GetxController {
  final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
  final AuthService _authService = Get.find<AuthService>();
  SupabaseClient get _client => Supabase.instance.client;

  int get _teacherId => int.parse(_authService.currentUser.value!.id);

  // خريطة student_id → avg_score من الاختبارات الرسمية
  final _studentAvgMap = <int, double>{};

  final isLoading = true.obs;
  final students = <StudentModel>[].obs;
  final filteredStudents = <StudentModel>[].obs;
  final classes = <ClassModel>[].obs;

  final searchQuery = ''.obs;
  final selectedClassId = Rxn<String>();
  final selectedMasteryLevel = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final classList = await _classesRepo.getAssignedClasses();
      classes.value = classList;
      final sectionIds = <String>{};
      for (final c in classList) {
        final sid = c.id.split('_').first;
        sectionIds.add(sid);
      }
      final allStudents = <StudentModel>[];
      for (final c in classList) {
        final sidStr = c.id.split('_').first;
        final sectionId = int.tryParse(sidStr);
        if (sectionId == null || sectionId <= 0) continue;
        final sectionName = c.name;
        final list = await _classesRepo.getStudentsBySection(
          sectionId: sectionId,
          sectionName: sectionName,
        );
        for (final s in list) {
          if (!allStudents.any((e) => e.id == s.id)) {
            allStudents.add(s);
          }
        }
      }
      students.value = allStudents;
      filteredStudents.value = allStudents;

      // جلب معدلات الاختبارات الرسمية لكل طالب
      await _loadStudentAverages(classList);
    } catch (e) {
      debugPrint('loadData error: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStudentAverages(List<ClassModel> classList) async {
    try {
      final Map<int, double> avgMap = {};
      // جلب المعدلات لكل section على حدة
      final sectionIds = <int>{};
      for (final c in classList) {
        final sid = int.tryParse(c.id.split('_').first) ?? 0;
        if (sid > 0) sectionIds.add(sid);
      }
      for (final sectionId in sectionIds) {
        final res = await _client.rpc(
          'get_section_students_with_avg',
          params: {'p_section_id': sectionId, 'p_teacher_id': _teacherId},
        );
        if (res != null) {
          for (final item in res as List) {
            final map = Map<String, dynamic>.from(item);
            final studentId = (map['student_id'] as num).toInt();
            final avgScore = (map['avg_score'] as num?)?.toDouble() ?? 0;
            avgMap[studentId] = avgScore;
          }
        }
      }
      _studentAvgMap.clear();
      _studentAvgMap.addAll(avgMap);

      // تحديث قوائم الطلاب بالمعدلات الحقيقية
      final updated = students.map((s) {
        final id = int.tryParse(s.id) ?? 0;
        final avg = _studentAvgMap[id] ?? 0.0;
        return StudentModel(
          id: s.id,
          name: s.name,
          email: s.email,
          studentCode: s.studentCode,
          classId: s.classId,
          className: s.className,
          profileImage: s.profileImage,
          averageScore: avg,
          totalQuizzes: s.totalQuizzes,
          completedQuizzes: s.completedQuizzes,
          masteryLevel: _getMasteryLevel(avg),
          subjectPerformance: s.subjectPerformance,
          lastActive: s.lastActive,
        );
      }).toList();

      students.value = updated;
      _applyFilters();
    } catch (e) {
      debugPrint('_loadStudentAverages error: \$e');
    }
  }

  String _getMasteryLevel(double avg) {
    if (avg >= 85) return 'Mastered';
    if (avg >= 70) return 'Proficient';
    if (avg >= 50) return 'Developing';
    return 'Needs Improvement';
  }

  void searchStudents(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByClass(String? classId) {
    selectedClassId.value = classId;
    _applyFilters();
  }

  void filterByMasteryLevel(String? level) {
    selectedMasteryLevel.value = level;
    _applyFilters();
  }

  void _applyFilters() {
    var result = students.toList();

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (student) =>
                student.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                student.studentCode.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    if (selectedClassId.value != null) {
      final sectionId = selectedClassId.value!.split('_').first;
      result = result.where((student) => student.classId == sectionId).toList();
    }

    if (selectedMasteryLevel.value != null) {
      result = result
          .where(
            (student) => student.masteryLevel == selectedMasteryLevel.value,
          )
          .toList();
    }

    filteredStudents.value = result;
  }

  void viewStudentDetail(StudentModel student) {
    Get.toNamed(AppRoutes.studentDetail, arguments: {'student': student});
  }

  Future<void> refreshStudents() async {
    await loadData();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedClassId.value = null;
    selectedMasteryLevel.value = null;
    filteredStudents.value = students;
  }
}
