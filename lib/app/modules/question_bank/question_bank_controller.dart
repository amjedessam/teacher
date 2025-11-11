import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/question_model.dart';
import '../../routes/app_routes.dart';

class QuestionBankController extends GetxController {
  final mockDataService = MockDataService();

  final isLoading = true.obs;
  final questions = <QuestionModel>[].obs;
  final filteredQuestions = <QuestionModel>[].obs;

  final searchQuery = ''.obs;
  final selectedDifficulty = Rxn<String>();
  final selectedChapter = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    questions.value = mockDataService.getQuestions();
    filteredQuestions.value = questions;

    isLoading.value = false;
  }

  void searchQuestions(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByDifficulty(String? difficulty) {
    selectedDifficulty.value = difficulty;
    _applyFilters();
  }

  void filterByChapter(String? chapter) {
    selectedChapter.value = chapter;
    _applyFilters();
  }

  void _applyFilters() {
    var result = questions.toList();

    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (q) =>
                q.questionText.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                q.chapter.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    if (selectedDifficulty.value != null) {
      result = result
          .where((q) => q.difficulty == selectedDifficulty.value)
          .toList();
    }

    if (selectedChapter.value != null) {
      result = result.where((q) => q.chapter == selectedChapter.value).toList();
    }

    filteredQuestions.value = result;
  }

  void addNewQuestion() {
    Get.toNamed(AppRoutes.addQuestion);
  }

  void editQuestion(QuestionModel question) {
    Get.toNamed(AppRoutes.addQuestion, arguments: {'question': question});
  }

  void deleteQuestion(QuestionModel question) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف السؤال'),
        content: const Text('هل أنت متأكد من حذف هذا السؤال؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              questions.removeWhere((q) => q.id == question.id);
              _applyFilters();
              Get.back();
              Get.snackbar('نجاح', 'تم حذف السؤال بنجاح');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void viewQuestionQuality() {
    Get.toNamed(AppRoutes.questionQuality);
  }

  Future<void> refreshQuestions() async {
    await loadQuestions();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedDifficulty.value = null;
    selectedChapter.value = null;
    filteredQuestions.value = questions;
  }
}
