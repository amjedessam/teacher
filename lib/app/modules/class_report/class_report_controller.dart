import 'package:get/get.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/class_model.dart';

class ClassReportController extends GetxController {
  final mockDataService = MockDataService();

  final classes = [].obs;
  final selectedClassId = Rxn();
  final students = [].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  void loadClasses() {
    classes.value = mockDataService.getClasses();
    if (classes.isNotEmpty) {
      selectedClassId.value = classes.first.id;
      loadStudents();
    }
  }

  Future loadStudents() async {
    if (selectedClassId.value == null) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    students.value = mockDataService.getStudents(
      classId: selectedClassId.value,
    );

    isLoading.value = false;
  }

  void changeClass(String? classId) {
    if (classId != null) {
      selectedClassId.value = classId;
      loadStudents();
    }
  }

  ClassModel? get selectedClass {
    if (selectedClassId.value == null) return null;
    return classes.firstWhereOrNull((c) => c.id == selectedClassId.value);
  }

  double get classAverage {
    if (students.isEmpty) return 0;
    return students.map((s) => s.averageScore).reduce((a, b) => a + b) /
        students.length;
  }

  int get excellentCount => students.where((s) => s.averageScore >= 90).length;
  int get goodCount =>
      students.where((s) => s.averageScore >= 70 && s.averageScore < 90).length;
  int get averageCount =>
      students.where((s) => s.averageScore >= 50 && s.averageScore < 70).length;
  int get weakCount => students.where((s) => s.averageScore < 50).length;

  List get topStudents {
    final sorted = List.from(students);
    sorted.sort((a, b) => b.averageScore.compareTo(a.averageScore));
    return sorted.take(5).toList();
  }

  List get strugglingStudents {
    return students.where((s) => s.averageScore < 60).toList();
  }
}
