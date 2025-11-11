// add_question_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddQuestionController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final explanationController = TextEditingController();

  final selectedDifficulty = 'medium'.obs;
  final selectedChapter = 'الجبر'.obs;
  final selectedQuestionType = 'mcq'.obs;

  final options = <String>[].obs;
  final correctOptionIndex = 0.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with 4 empty options
    options.value = ['', '', '', ''];
  }

  @override
  void onClose() {
    questionController.dispose();
    explanationController.dispose();
    super.onClose();
  }

  void updateOption(int index, String value) {
    options[index] = value;
  }

  void setCorrectOption(int index) {
    correctOptionIndex.value = index;
  }

  void addOption() {
    if (options.length < 6) {
      options.add('');
    }
  }

  void removeOption(int index) {
    if (options.length > 2) {
      options.removeAt(index);
      if (correctOptionIndex.value >= options.length) {
        correctOptionIndex.value = options.length - 1;
      }
    }
  }

  Future<void> saveQuestion() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Check if all options are filled
    if (options.any((opt) => opt.trim().isEmpty)) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الخيارات');
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.back();
    Get.snackbar(
      'نجاح',
      'تم إضافة السؤال بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
