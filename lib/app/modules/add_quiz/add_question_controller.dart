import 'dart:convert';
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

// ── ثوابت المهارات ─────────────────────────────────────────────────────────
class SkillOption {
  final String value;
  final String label;
  final String emoji;
  final Color color;
  final Color bgColor;

  const SkillOption({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
    required this.bgColor,
  });
}

const List<SkillOption> kSkillOptions = [
  SkillOption(
    value: 'remember',
    label: 'تذكر',
    emoji: '🧠',
    color: Color(0xFF1D4ED8),
    bgColor: Color(0xFFEFF6FF),
  ),
  SkillOption(
    value: 'understand',
    label: 'فهم',
    emoji: '💡',
    color: Color(0xFF15803D),
    bgColor: Color(0xFFF0FDF4),
  ),
  SkillOption(
    value: 'apply',
    label: 'تطبيق',
    emoji: '🔧',
    color: Color(0xFFB45309),
    bgColor: Color(0xFFFFFBEB),
  ),
  SkillOption(
    value: 'analyze',
    label: 'تحليل',
    emoji: '🔍',
    color: Color(0xFF7C3AED),
    bgColor: Color(0xFFF5F3FF),
  ),
];

// ── helper: إيجاد SkillOption من القيمة ───────────────────────────────────
SkillOption? findSkill(String value) {
  try {
    return kSkillOptions.firstWhere((s) => s.value == value);
  } catch (_) {
    return null;
  }
}

// ══════════════════════════════════════════════════════════════════════════════

class AddQuestionController extends GetxController {
  SupabaseClient get _client => Supabase.instance.client;

  final formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final explanationController = TextEditingController();

  // المادة
  final subjects = <ClassModel>[].obs;
  final selectedSubjectId = Rxn<int>();

  // الفصول
  final chapters = <ChapterItem>[].obs;
  final selectedChapterId = Rxn<int>();

  // باقي الحقول
  final selectedDifficulty = 'medium'.obs;
  final selectedQuestionType = 'mcq'.obs;
  final options = <String>[].obs;
  final correctOptionIndex = 0.obs;
  final isLoading = false.obs;

  // ── مهارة بلوم ──────────────────────────────────────────────────────────
  /// القيمة المختارة: 'remember' | 'understand' | 'apply' | 'analyze' | ''
  final selectedSkill = ''.obs;

  /// true أثناء استدعاء Edge Function
  final skillLoading = false.obs;

  /// رسالة خطأ خاصة بالمهارة (تُعرض أسفل الحقل)
  final skillError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    options.value = ['', '', '', ''];
    _loadSubjects();

    // عند تغيير المادة → جلب فصولها
    ever(selectedSubjectId, (id) {
      if (id != null) _loadChapters(id);
    });

    // عند تغيير نص السؤال → مسح رسالة الخطأ القديمة
    questionController.addListener(() {
      if (skillError.value.isNotEmpty) skillError.value = '';
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

  // ── جلب فصول المادة المختارة ───────────────────────────────────────────
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
  void updateOption(int index, String value) => options[index] = value;

  void setCorrectOption(int index) => correctOptionIndex.value = index;

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

  // ══════════════════════════════════════════════════════════════════════════
  // ── تحديد مهارة بلوم تلقائياً عبر Supabase Edge Function ──────────────
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> detectSkill() async {
    final text = questionController.text.trim();

    // ① التحقق من وجود نص السؤال
    if (text.isEmpty) {
      skillError.value = 'اكتب نص السؤال أولاً قبل التحديد التلقائي';
      return;
    }

    skillLoading.value = true;
    skillError.value = '';

    try {
      // ② استدعاء Edge Function — JWT verification معطّل على الدالة
      final response = await _client.functions.invoke(
        'detect-skill',
        body: {'question_text': text},
      );

      // ③ استخراج القيمة — الـ SDK أحياناً يرجع String أحياناً Map
      String skill = '';
      final raw = response.data;

      if (raw is Map) {
        // الحالة الطبيعية: Map مباشرة
        skill = raw['skill']?.toString() ?? '';
      } else if (raw is String) {
        // بعض إصدارات الـ SDK ترجع JSON String — نحوله يدوياً
        try {
          final decoded = jsonDecode(raw) as Map<String, dynamic>;
          skill = decoded['skill']?.toString() ?? '';
        } catch (_) {
          skill = '';
        }
      }

      // ④ التحقق من صحة القيمة
      final validSkills = kSkillOptions.map((s) => s.value).toList();
      if (skill.isNotEmpty && validSkills.contains(skill)) {
        selectedSkill.value = skill;
        skillError.value = '';
      } else {
        debugPrint('detectSkill: unexpected response → $raw');
        skillError.value = 'لم يتمكن النظام من التحديد — اختر يدوياً';
      }
    } on FunctionException catch (e) {
      debugPrint('detectSkill FunctionException: ${e.details}');
      skillError.value = 'فشل الاتصال بالخدمة — اختر يدوياً';
    } catch (e) {
      debugPrint('detectSkill error: $e');
      skillError.value = 'حدث خطأ غير متوقع — اختر يدوياً';
    } finally {
      skillLoading.value = false;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── حفظ السؤال ─────────────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════
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
        ),
        'times_used': 0,
        'times_correct': 0,
        'times_incorrect': 0,

        // ── مهارة بلوم: null لو لم يختر المعلم ──────────────────────────
        'skill': selectedSkill.value.isEmpty ? null : selectedSkill.value,
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
