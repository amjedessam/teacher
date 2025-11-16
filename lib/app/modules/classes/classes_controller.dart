import 'package:get/get.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/class_model.dart';

class ClassesController extends GetxController {
  final mockDataService = MockDataService();

  final isLoading = true.obs;
  final classes = <ClassModel>[].obs;
  final filteredClasses = <ClassModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  Future<void> loadClasses() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    classes.value = mockDataService.getClasses();
    filteredClasses.value = classes;

    isLoading.value = false;
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
