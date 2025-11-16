import 'package:get/get.dart';
import 'main_navigation_controller.dart';
import '../dashboard/dashboard_controller.dart';
import '../classes/classes_controller.dart';
import '../students/students_controller.dart';
import '../question_bank/question_bank_controller.dart';
import '../profile/profile_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ClassesController>(() => ClassesController());
    Get.lazyPut<StudentsController>(() => StudentsController());
    Get.lazyPut<QuestionBankController>(() => QuestionBankController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
