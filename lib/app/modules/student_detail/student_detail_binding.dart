import 'package:get/get.dart';
import 'student_detail_controller.dart';

class StudentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentDetailController>(() => StudentDetailController());
  }
}
