import 'package:get/get.dart';
import '../dashboard/dashboard_view.dart';
import '../classes/classes_view.dart';
import '../students/students_view.dart';
import '../question_bank/question_bank_view.dart';
import '../profile/profile_view.dart';

class MainNavigationController extends GetxController {
  final currentIndex = 2.obs;

  final screens = [
    const StudentsView(),
    const ClassesView(),
    const DashboardView(),
    const QuestionBankView(),
    const ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
