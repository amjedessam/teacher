// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import 'main_navigation_controller.dart';
// import '../dashboard/dashboard_view.dart';
// import '../classes/classes_view.dart';
// import '../students/students_view.dart';
// import '../question_bank/question_bank_view.dart';
// import '../profile/profile_view.dart';

// class MainNavigationView extends GetView<MainNavigationController> {
//   const MainNavigationView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       const DashboardView(),
//       const ClassesView(),
//       const StudentsView(),
//       const QuestionBankView(),
//       const ProfileView(),
//     ];

//     return Obx(
//       () => Scaffold(
//         body: IndexedStack(
//           index: controller.currentIndex.value,
//           children: pages,
//         ),
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: BottomNavigationBar(
//             currentIndex: controller.currentIndex.value,
//             onTap: controller.changePage,
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Colors.white,
//             selectedItemColor: AppColors.primary,
//             unselectedItemColor: AppColors.textLight,
//             selectedFontSize: 12,
//             unselectedFontSize: 12,
//             elevation: 0,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.dashboard_outlined),
//                 activeIcon: Icon(Icons.dashboard),
//                 label: 'الرئيسية',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.class_outlined),
//                 activeIcon: Icon(Icons.class_),
//                 label: 'الفصول',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.people_outline),
//                 activeIcon: Icon(Icons.people),
//                 label: 'الطلاب',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.quiz_outlined),
//                 activeIcon: Icon(Icons.quiz),
//                 label: 'الأسئلة',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person_outline),
//                 activeIcon: Icon(Icons.person),
//                 label: 'الملف',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // إضافة المكتبة
import '../../core/theme/app_colors.dart';
import 'main_navigation_controller.dart';
// import '../dashboard/dashboard_view.dart';
// import '../classes/classes_view.dart';
// import '../students/students_view.dart';
// import '../question_bank/question_bank_view.dart';
// import '../profile/profile_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.screens, // استخدام screens من Controller
        ),
      ),
      bottomNavigationBar: _buildCurvedBottomNav(),
    );
  }

  Widget _buildCurvedBottomNav() {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => CurvedNavigationBar(
                index: controller.currentIndex.value,
                height: 70,
                backgroundColor: Colors.transparent,
                color: AppColors.primary,
                buttonBackgroundColor: AppColors.primaryDark,
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                onTap: controller.changePage,
                items: [
                  _buildNavIcon(Icons.people, 0),
                  _buildNavIcon(Icons.class_, 1),
                  _buildNavIcon(Icons.dashboard, 2, isCenter: true), // المركز
                  _buildNavIcon(Icons.quiz, 3),
                  _buildNavIcon(Icons.person, 4),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLabel('الطلاب', 0),
                  _buildLabel('الفصول', 1),
                  const SizedBox(width: 60), // مساحة فارغة للزر المركزي
                  _buildLabel('الأسئلة', 3),
                  _buildLabel('الملف', 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool isCenter = false}) {
    final isSelected = controller.currentIndex.value == index;

    return Icon(
      icon,
      size: isCenter ? 35 : (isSelected ? 30 : 26),
      color: Colors.white,
    );
  }

  Widget _buildLabel(String text, int index) {
    final isSelected = controller.currentIndex.value == index;

    return AnimatedOpacity(
      opacity: isSelected ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
