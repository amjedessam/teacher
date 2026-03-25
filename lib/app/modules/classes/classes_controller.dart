import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/models/class_model.dart';
import '../../data/services/auth_service.dart';

class ClassesController extends GetxController {
  final ClassesRepository _classesRepo = Get.find<ClassesRepository>();
  final AuthService _authService = Get.find<AuthService>();
  SupabaseClient get _client => Supabase.instance.client;
  int get _teacherId => int.parse(_authService.currentUser.value!.id);

  final isLoading = true.obs;
  final classes = <ClassModel>[].obs;
  final filteredClasses = <ClassModel>[].obs;
  final searchQuery = ''.obs;

  // خريطة sectionId → {totalExams, avgScore}
  final classStatsMap = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  Future<void> loadClasses() async {
    isLoading.value = true;
    try {
      final list = await _classesRepo.getAssignedClasses();
      classes.value = list;
      filteredClasses.value = list;
      // جلب إحصائيات كل فصل
      await _loadClassStats(list);
    } catch (e) {
      debugPrint('loadClasses error: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadClassStats(List<ClassModel> classList) async {
    try {
      final Map<String, Map<String, dynamic>> statsMap = {};
      for (final c in classList) {
        final sectionId = int.tryParse(c.id.split('_').first) ?? 0;
        if (sectionId <= 0) continue;
        final res = await _client.rpc(
          'get_class_exams_with_stats',
          params: {'p_section_id': sectionId, 'p_teacher_id': _teacherId},
        );
        if (res != null && res is List && res.isNotEmpty) {
          final scores = (res as List)
              .map((e) => (e as Map)['average_score'])
              .where((s) => s != null)
              .map((s) => (s as num).toDouble())
              .toList();
          statsMap[sectionId.toString()] = {
            'totalExams': res.length,
            'avgScore': scores.isEmpty
                ? 0.0
                : scores.reduce((a, b) => a + b) / scores.length,
          };
        } else {
          statsMap[sectionId.toString()] = {'totalExams': 0, 'avgScore': 0.0};
        }
      }
      classStatsMap.value = statsMap;
    } catch (e) {
      debugPrint('_loadClassStats error: \$e');
    }
  }

  // helpers للـ View
  int getClassExamCount(String classId) {
    final sectionId = classId.split('_').first;
    return (classStatsMap[sectionId]?['totalExams'] as int?) ?? 0;
  }

  double getClassAvgScore(String classId) {
    final sectionId = classId.split('_').first;
    return (classStatsMap[sectionId]?['avgScore'] as double?) ?? 0.0;
  }

  void searchClasses(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredClasses.value = classes;
    } else {
      filteredClasses.value = classes
          .where(
            (classItem) =>
                classItem.name.toLowerCase().contains(query.toLowerCase()) ||
                classItem.subject.toLowerCase().contains(query.toLowerCase()) ||
                classItem.grade.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  Future<void> refreshClasses() async {
    await loadClasses();
  }

  void viewClassDetails(ClassModel classItem) {
    Get.toNamed(AppRoutes.classDetail, arguments: {'class': classItem});
  }
}
