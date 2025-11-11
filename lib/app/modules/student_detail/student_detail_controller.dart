import 'package:get/get.dart';
import '../../data/models/student_model.dart';

class StudentDetailController extends GetxController {
  final student = Rxn<StudentModel>();
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['student'] != null) {
      student.value = arguments['student'] as StudentModel;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void sendMessage() {
    Get.snackbar('رسالة', 'تم إرسال رسالة إلى ${student.value?.name}');
  }

  void callStudent() {
    Get.snackbar('اتصال', 'جاري الاتصال بـ ${student.value?.name}');
  }
}
