import 'package:get/get.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/student_model.dart';
import '../../data/models/class_model.dart';
import '../../routes/app_routes.dart';

class StudentsController extends GetxController {
  final mockDataService = MockDataService();

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

    await Future.delayed(const Duration(milliseconds: 800));

    students.value = mockDataService.getStudents();
    classes.value = mockDataService.getClasses();
    filteredStudents.value = students;

    isLoading.value = false;
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

    // Class filter
    if (selectedClassId.value != null) {
      result = result
          .where((student) => student.classId == selectedClassId.value)
          .toList();
    }

    // Mastery level filter
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
