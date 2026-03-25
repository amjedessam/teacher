import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/question_model.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class QuestionBankController extends GetxController {
  final QuestionRepository _questionRepo = Get.find();
  SupabaseClient get _client => Supabase.instance.client;

  final isLoading = true.obs;
  final questions = <QuestionModel>[].obs;
  final filteredQuestions = <QuestionModel>[].obs;

  final searchQuery = ''.obs;
  final selectedDifficulty = Rxn<String>();
  final selectedSubjectId = Rxn<String>(); // ✅ فلتر بالمادة بدلاً من الفصل

  // قائمة المواد المتاحة للمعلم
  final availableSubjects = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;
      final loadedQuestions = await _questionRepo.getQuestions();
      questions.value = loadedQuestions;
      filteredQuestions.value = loadedQuestions;

      // استخراج المواد المتاحة من البيانات
      final subjectsMap = <String, String>{};
      for (final q in loadedQuestions) {
        if (q.subjectId.isNotEmpty && q.subject.isNotEmpty) {
          subjectsMap[q.subjectId] = q.subject;
        }
      }
      availableSubjects.value = subjectsMap.entries
          .map((e) => {'id': e.key, 'name': e.value})
          .toList();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل تحميل الأسئلة: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchQuestions(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByDifficulty(String? difficulty) {
    selectedDifficulty.value = difficulty;
    _applyFilters();
  }

  void filterBySubject(String? subjectId) {
    selectedSubjectId.value = subjectId;
    _applyFilters();
  }

  void _applyFilters() {
    var result = questions.toList();

    // فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (q) => q.questionText.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }

    // فلتر المادة
    if (selectedSubjectId.value != null) {
      result = result
          .where((q) => q.subjectId == selectedSubjectId.value)
          .toList();
    }

    // فلتر الصعوبة
    if (selectedDifficulty.value != null) {
      result = result
          .where((q) => q.difficulty == selectedDifficulty.value)
          .toList();
    }

    filteredQuestions.value = result;
  }

  bool get hasActiveFilters =>
      selectedSubjectId.value != null || selectedDifficulty.value != null;

  void addNewQuestion() => Get.toNamed(AppRoutes.addQuestion);

  void editQuestion(QuestionModel question) =>
      Get.toNamed(AppRoutes.addQuestion, arguments: {'question': question});

  void deleteQuestion(QuestionModel question) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف السؤال'),
        content: const Text('هل أنت متأكد من حذف هذا السؤال؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _questionRepo.deleteQuestion(question.id);
                questions.removeWhere((q) => q.id == question.id);
                _applyFilters();
                Get.back();
                Get.snackbar(
                  'تم',
                  'تم حذف السؤال بنجاح',
                  backgroundColor: Colors.green.shade100,
                  colorText: Colors.green.shade900,
                );
              } catch (e) {
                Get.snackbar('خطأ', 'فشل حذف السؤال');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> refreshQuestions() async => loadQuestions();

  void clearFilters() {
    searchQuery.value = '';
    selectedDifficulty.value = null;
    selectedSubjectId.value = null;
    filteredQuestions.value = questions;
  }

  String getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'سهل';
      case 'medium':
        return 'متوسط';
      case 'hard':
        return 'صعب';
      default:
        return difficulty;
    }
  }

  Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String getTypeLabel(String type) {
    switch (type) {
      case 'mcq':
      case 'multiple_choice':
        return 'اختيار متعدد';
      case 'true_false':
        return 'صح / خطأ';
      case 'essay':
        return 'مقالي';
      case 'fill_blank':
        return 'فراغات';
      default:
        return type;
    }
  }
}
