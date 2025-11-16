import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../core/theme/app_colors.dart';
import 'main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.screens,
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
                  _buildNavIcon(Icons.dashboard, 2, isCenter: true),
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
                  const SizedBox(width: 60),
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
