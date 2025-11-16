// quiz_builder_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/class_model.dart';
import '../../data/models/question_model.dart';

class QuizBuilderController extends GetxController {
  final mockDataService = MockDataService();
  final formKey = GlobalKey<FormState>();

  final classes = <ClassModel>[].obs;
  final selectedClassId = Rxn<String>();
  final selectedChapter = 'الجبر'.obs;
  final selectedUnit = 'المعادلات الخطية'.obs;

  final questionCount = 20.obs;
  final easyPercentage = 20.obs;
  final mediumPercentage = 60.obs;
  final hardPercentage = 20.obs;

  final generatedQuestions = <QuestionModel>[].obs;
  final isGenerating = false.obs;
  final isPreviewMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  void loadClasses() {
    classes.value = mockDataService.getClasses();
    if (classes.isNotEmpty) {
      selectedClassId.value = classes.first.id;
    }
  }

  void updateQuestionCount(double value) {
    questionCount.value = value.round();
  }

  void updateEasyPercentage(double value) {
    easyPercentage.value = value.round();
    _balancePercentages('easy');
  }

  void updateMediumPercentage(double value) {
    mediumPercentage.value = value.round();
    _balancePercentages('medium');
  }

  void updateHardPercentage(double value) {
    hardPercentage.value = value.round();
    _balancePercentages('hard');
  }

  void _balancePercentages(String changed) {
    int total =
        easyPercentage.value + mediumPercentage.value + hardPercentage.value;

    if (total != 100) {
      int diff = 100 - total;
      if (changed != 'medium') {
        mediumPercentage.value = (mediumPercentage.value + diff).clamp(0, 100);
      } else if (changed != 'easy') {
        easyPercentage.value = (easyPercentage.value + diff).clamp(0, 100);
      }
    }
  }

  Future<void> generateQuiz() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isGenerating.value = true;
    await Future.delayed(const Duration(seconds: 2));

    final allQuestions = mockDataService.getQuestions(
      chapter: selectedChapter.value,
    );

    final easyCount = ((questionCount.value * easyPercentage.value) / 100)
        .round();
    final mediumCount = ((questionCount.value * mediumPercentage.value) / 100)
        .round();
    final hardCount = questionCount.value - easyCount - mediumCount;

    final easyQuestions = allQuestions
        .where((q) => q.difficulty == 'easy')
        .take(easyCount);
    final mediumQuestions = allQuestions
        .where((q) => q.difficulty == 'medium')
        .take(mediumCount);
    final hardQuestions = allQuestions
        .where((q) => q.difficulty == 'hard')
        .take(hardCount);

    generatedQuestions.value = [
      ...easyQuestions,
      ...mediumQuestions,
      ...hardQuestions,
    ]..shuffle();

    isGenerating.value = false;
    isPreviewMode.value = true;
  }

  void exportToPDF() {
    Get.snackbar(
      'تصدير PDF',
      'جاري تصدير الاختبار إلى PDF...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void sendToStudents() {
    Get.dialog(
      AlertDialog(
        title: const Text('إرسال الاختبار'),
        content: const Text('هل تريد إرسال هذا الاختبار لطلاب الفصل المحدد؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'تم الإرسال',
                'تم إرسال الاختبار بنجاح للطلاب',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void backToBuilder() {
    isPreviewMode.value = false;
  }
}
