import 'package:get/get.dart';
import '../../data/models/class_model.dart';
import '../../data/models/student_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../routes/app_routes.dart';

class ClassDetailController extends GetxController {
  final mockDataService = MockDataService();

  final classItem = Rxn<ClassModel>();
  final students = <StudentModel>[].obs;
  final isLoading = true.obs;
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['class'] != null) {
      classItem.value = arguments['class'] as ClassModel;
      loadStudents();
    }
  }

  Future<void> loadStudents() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    if (classItem.value != null) {
      students.value = mockDataService.getStudents(
        classId: classItem.value!.id,
      );
    }

    isLoading.value = false;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void viewStudentDetail(StudentModel student) {
    Get.toNamed(AppRoutes.studentDetail, arguments: {'student': student});
  }

  void sendMessageToClass() {
    Get.snackbar(
      'رسالة جماعية',
      'سيتم إرسال رسالة لجميع طلاب ${classItem.value?.name}',
    );
  }

  void createQuizForClass() {
    Get.snackbar(
      'إنشاء اختبار',
      'سيتم إنشاء اختبار لـ ${classItem.value?.name}',
    );
  }
}
