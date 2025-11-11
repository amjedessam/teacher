// import 'package:get/get.dart';

// class MainNavigationController extends GetxController {
//   final currentIndex = 0.obs;

//   void changePage(int index) {
//     currentIndex.value = index;
//   }
// }

import 'package:get/get.dart';
import '../dashboard/dashboard_view.dart';
import '../classes/classes_view.dart';
import '../students/students_view.dart';
import '../question_bank/question_bank_view.dart';
import '../profile/profile_view.dart';

class MainNavigationController extends GetxController {
  // تم تغيير الاسم من selectedIndex إلى currentIndex للحفاظ على التوافق مع View
  final currentIndex = 2.obs; // البدء من الشاشة المركزية (الطلاب)

  // تعريف قائمة الشاشات (Screens)
  final screens = [
    const StudentsView(), // الشاشة المركزية
    const ClassesView(),
    const DashboardView(),
    const QuestionBankView(),
    const ProfileView(),
  ];

  // دالة تغيير الفهرس (Index)
  void changePage(int index) {
    currentIndex.value = index;
  }
}
