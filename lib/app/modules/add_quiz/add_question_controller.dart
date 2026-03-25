import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher/app/data/services/auth_service.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/models/class_model.dart';

class ChapterItem {
  final int id;
  final String name;
  ChapterItem({required this.id, required this.name});
}

class AddQuestionController extends GetxController {
  SupabaseClient get _client => Supabase.instance.client;

  final formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final explanationController = TextEditingController();

  // المادة
  final subjects = <ClassModel>[].obs;
  final selectedSubjectId = Rxn<int>();

  // الفصول — تُحدَّث عند تغيير المادة
  final chapters = <ChapterItem>[].obs;
  final selectedChapterId = Rxn<int>();

  // باقي الحقول
  final selectedDifficulty = 'medium'.obs;
  final selectedQuestionType = 'mcq'.obs;
  final options = <String>[].obs;
  final correctOptionIndex = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    options.value = ['', '', '', ''];
    _loadSubjects();

    // عند تغيير المادة → جلب فصولها
    ever(selectedSubjectId, (id) {
      if (id != null) _loadChapters(id);
    });
  }

  @override
  void onClose() {
    questionController.dispose();
    explanationController.dispose();
    super.onClose();
  }

  // ── جلب المواد المعيّنة للمعلم ─────────────────────────────────────────
  Future<void> _loadSubjects() async {
    try {
      final repo = Get.find<ClassesRepository>();
      final list = await repo.getAssignedClasses();

      // إزالة التكرار حسب subject_id
      final bySubject = <int, ClassModel>{};
      for (final c in list) {
        if (c.subjectId != null && !bySubject.containsKey(c.subjectId)) {
          bySubject[c.subjectId!] = c;
        }
      }

      subjects.value = bySubject.values.toList();

      if (subjects.isNotEmpty && selectedSubjectId.value == null) {
        selectedSubjectId.value = subjects.first.subjectId;
      }
    } catch (e) {
      debugPrint('_loadSubjects error: $e');
    }
  }

  // ── جلب فصول المادة المختارة من جدول chapters ─────────────────────────
  Future<void> _loadChapters(int subjectId) async {
    try {
      selectedChapterId.value = null;
      chapters.clear();

      final res = await _client
          .from('chapters')
          .select('id, name')
          .eq('subject_id', subjectId)
          .eq('is_active', true)
          .order('order_index', ascending: true);

      final list = res as List;
      chapters.value = list
          .map(
            (e) => ChapterItem(
              id: e['id'] as int,
              name: e['name']?.toString() ?? '',
            ),
          )
          .toList();

      if (chapters.isNotEmpty) {
        selectedChapterId.value = chapters.first.id;
      }
    } catch (e) {
      debugPrint('_loadChapters error: $e');
    }
  }

  // ── إدارة الخيارات ─────────────────────────────────────────────────────
  void updateOption(int index, String value) {
    options[index] = value;
  }

  void setCorrectOption(int index) {
    correctOptionIndex.value = index;
  }

  void addOption() {
    if (options.length < 6) options.add('');
  }

  void removeOption(int index) {
    if (options.length > 2) {
      options.removeAt(index);
      if (correctOptionIndex.value >= options.length) {
        correctOptionIndex.value = options.length - 1;
      }
    }
  }

  // ── حفظ السؤال مباشرة في جدول questions ──────────────────────────────
  Future<void> saveQuestion() async {
    if (!formKey.currentState!.validate()) return;

    final sid = selectedSubjectId.value;
    if (sid == null) {
      Get.snackbar('خطأ', 'يرجى اختيار المادة');
      return;
    }

    final cid = selectedChapterId.value;
    if (cid == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الفصل');
      return;
    }

    final trimmedOptions = options.map((e) => e.trim()).toList();
    if (trimmedOptions.any((opt) => opt.isEmpty)) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الخيارات');
      return;
    }

    isLoading.value = true;
    try {
      // بناء الخيارات بصيغة JSONB
      final optionsJson = List.generate(
        trimmedOptions.length,
        (i) => {
          'id': 'O${i + 1}',
          'text': trimmedOptions[i],
          'is_correct': i == correctOptionIndex.value,
        },
      );

      await _client.from('questions').insert({
        'question_text': questionController.text.trim(),
        'question_type': selectedQuestionType.value,
        'question_options': optionsJson,
        'correct_answer': trimmedOptions[correctOptionIndex.value],
        'explanation': explanationController.text.trim().isEmpty
            ? null
            : explanationController.text.trim(),
        'difficulty_level': selectedDifficulty.value,
        'subject_id': sid,
        'chapter_id': cid,
        'is_active': true,
        'status': 'approved',
        'created_by_teacher': int.parse(
          Get.find<AuthService>().currentUser.value!.id,
        ), // ✅ مطلوب للـ RLS
        'times_used': 0,
        'times_correct': 0,
        'times_incorrect': 0,
      });

      Get.back();
      Get.snackbar(
        'تم الحفظ ✅',
        'تم إضافة السؤال إلى قاعدة البيانات بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('saveQuestion error: $e');
      Get.snackbar(
        'خطأ',
        'فشل حفظ السؤال: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
