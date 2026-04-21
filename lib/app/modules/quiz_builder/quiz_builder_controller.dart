import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher/app/routes/app_routes.dart';
import '../../data/models/class_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/student_model.dart';
import '../../data/repositories/classes_repository.dart';
import '../../data/services/ai_service.dart';
import '../../data/services/auth_service.dart';

class ChapterOption {
  final int id;
  final String name;
  ChapterOption({required this.id, required this.name});
}

class SectionOption {
  final int id;
  final String name;
  SectionOption({required this.id, required this.name});
}

class QuizBuilderController extends GetxController {
  SupabaseClient get _client => Supabase.instance.client;

  // ── Step tracking ──────────────────────────────────────────────────────────
  final currentStep = 0.obs; // 0: الإعدادات  1: اختيار الأسئلة  2: مراجعة

  // ── Step 0: إعدادات الاختبار ───────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController(text: '30');
  final passingMarksController = TextEditingController(text: '50');

  void addNewQuestion() {
    Get.toNamed(AppRoutes.questionBank);
  }

  final subjects = <ClassModel>[].obs;
  final selectedSubjectId = Rxn<int>();
  final selectedGradeId = Rxn<int>();
  final selectedSubjectName = ''.obs;

  final sections = <SectionOption>[].obs;
  final selectedSectionId = Rxn<int>();

  final chapters = <ChapterOption>[].obs;
  final selectedChapterId = Rxn<int>();

  final selectedDifficulty = Rxn<String>();
  final selectedSemesterId = 1.obs;

  // ── Step 1: اختيار الأسئلة ─────────────────────────────────────────────────
  final allQuestions = <QuestionModel>[].obs;
  final selectedQuestionIds = <String>{}.obs;
  final isLoadingQuestions = false.obs;
  final isGeneratingQuestions = false.obs;

  //AiService get _aiService => Get.find<AiService>();

  // ── وضع الطالب الفردي ─────────────────────────────────────────────────────
  bool isStudentMode = false;
  int? targetStudentId;
  final targetStudentName = ''.obs;

  // ── Loading / Saving ───────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();

    // التحقق إذا كان قادماً من تفاصيل طالب
    final args = Get.arguments;
    if (args is Map && args['student'] != null) {
      final student = args['student'] as StudentModel;
      isStudentMode = true;
      targetStudentId = int.tryParse(student.id);
      targetStudentName.value = student.name;
      final sectionId = int.tryParse(student.classId);
      if (sectionId != null) selectedSectionId.value = sectionId;
    }

    _loadSubjects();
    ever(selectedSubjectId, (_) => _onSubjectChanged());
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    passingMarksController.dispose();
    super.onClose();
  }

  // ── جلب المواد ────────────────────────────────────────────────────────────
  Future<void> _loadSubjects() async {
    try {
      isLoading.value = true;
      final repo = Get.find<ClassesRepository>();
      final list = await repo.getAssignedClasses();
      final bySubject = <int, ClassModel>{};
      for (final c in list) {
        if (c.subjectId != null && !bySubject.containsKey(c.subjectId)) {
          bySubject[c.subjectId!] = c;
        }
      }
      subjects.value = bySubject.values.toList();
      if (subjects.isNotEmpty) {
        selectedSubjectId.value = subjects.first.subjectId;
      }
    } catch (e) {
      debugPrint('_loadSubjects error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── عند تغيير المادة ─────────────────────────────────────────────────────
  Future<void> _onSubjectChanged() async {
    final sid = selectedSubjectId.value;
    if (sid == null) return;

    final subj = subjects.firstWhereOrNull((s) => s.subjectId == sid);
    selectedSubjectName.value = subj?.subject ?? '';

    // في وضع الطالب الفردي لا نصفّر sectionId لأنه مُحدد من بيانات الطالب
    if (!isStudentMode) selectedSectionId.value = null;
    selectedChapterId.value = null;
    chapters.clear();
    if (!isStudentMode) sections.clear();
    allQuestions.clear();
    selectedQuestionIds.clear();

    if (isStudentMode) {
      await _loadChapters(sid);
      // جلب gradeId من section الطالب
      await _loadGradeForSection();
    } else {
      await Future.wait([_loadSections(sid), _loadChapters(sid)]);
    }
  }

  Future<void> _loadGradeForSection() async {
    try {
      if (selectedSectionId.value == null) return;
      final res = await _client
          .from('sections')
          .select('grade_id')
          .eq('id', selectedSectionId.value!)
          .single();
      selectedGradeId.value = res['grade_id'] as int?;
    } catch (e) {
      debugPrint('_loadGradeForSection error: $e');
    }
  }

  Future<void> _loadSections(int subjectId) async {
    try {
      final teacherId = _teacherId;
      final res = await _client
          .from('section_subjects')
          .select('section_id, sections(id, name, grade_id)')
          .eq('teacher_id', teacherId)
          .eq('subject_id', subjectId)
          .eq('is_active', true);

      final list = res as List;
      sections.value = list.map((e) {
        final sec = e['sections'] as Map<String, dynamic>;
        return SectionOption(
          id: sec['id'] as int,
          name: sec['name']?.toString() ?? '',
        );
      }).toList();

      if (sections.isNotEmpty) {
        selectedSectionId.value = sections.first.id;
        final firstSec = list.first['sections'] as Map<String, dynamic>;
        selectedGradeId.value = firstSec['grade_id'] as int?;
      }
    } catch (e) {
      debugPrint('_loadSections error: $e');
    }
  }

  Future<void> _loadChapters(int subjectId) async {
    try {
      final res = await _client
          .from('chapters')
          .select('id, name')
          .eq('subject_id', subjectId)
          .eq('is_active', true)
          .order('id', ascending: true);

      final list = res as List;
      chapters.value = list
          .map(
            (e) => ChapterOption(
              id: e['id'] as int,
              name: e['name']?.toString() ?? '',
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('_loadChapters error: $e');
    }
  }

  // ── Step 0 → Step 1 ───────────────────────────────────────────────────────
  Future<void> goToSelectQuestions() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedSectionId.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الفصل الدراسي');
      return;
    }

    isLoadingQuestions.value = true;
    try {
      var query = _client
          .from('questions')
          .select('*, subjects(name)')
          .eq('subject_id', selectedSubjectId.value!)
          .eq('is_active', true)
          .eq('status', 'approved');

      if (selectedChapterId.value != null) {
        query = query.eq('chapter_id', selectedChapterId.value!);
      }
      if (selectedDifficulty.value != null) {
        query = query.eq('difficulty_level', selectedDifficulty.value!);
      }

      final res = await query.order('created_at', ascending: false);
      final list = res as List;

      allQuestions.value = list
          .map(
            (e) => QuestionModel.fromQuestionRow(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();

      if (allQuestions.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا توجد أسئلة لهذه المادة بعد — أضف أسئلة أولاً',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
        return;
      }

      currentStep.value = 1;
    } catch (e) {
      debugPrint('goToSelectQuestions error: $e');
      Get.snackbar('خطأ', 'فشل تحميل الأسئلة: $e');
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  // ── تحديد / إلغاء سؤال ───────────────────────────────────────────────────
  void toggleQuestion(String questionId) {
    if (selectedQuestionIds.contains(questionId)) {
      selectedQuestionIds.remove(questionId);
    } else {
      selectedQuestionIds.add(questionId);
    }
    selectedQuestionIds.refresh();
  }

  bool isSelected(String questionId) =>
      selectedQuestionIds.contains(questionId);

  // ── Step 1 → Step 2 ───────────────────────────────────────────────────────
  void goToReview() {
    if (selectedQuestionIds.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار سؤال واحد على الأقل');
      return;
    }
    currentStep.value = 2;
  }

  Future<void> generateQuestionsByAI() async {
    // if (selectedSubjectId.value == null) {
    //   Get.snackbar('خطأ', 'اختر المادة أولاً لتوليد أسئلة ذكية');
    //   return;
    // }

    // isGeneratingQuestions.value = true;
    // try {
    //   final chapterName = selectedChapterId.value == null
    //       ? null
    //       : chapters
    //             .firstWhere(
    //               (ch) => ch.id == selectedChapterId.value,
    //               orElse: () => ChapterOption(id: 0, name: ''),
    //             )
    //             .name;
    //   final generated = await _aiService.generateQuestions(
    //     subject: selectedSubjectName.value.isNotEmpty
    //         ? selectedSubjectName.value
    //         : subjects
    //               .firstWhere((s) => s.subjectId == selectedSubjectId.value)
    //               .subject,
    //     chapter: chapterName,
    //     difficulty: selectedDifficulty.value ?? 'medium',
    //     count: 4,
    //   );

    //   if (generated.isEmpty) {
    //     Get.snackbar(
    //       'تنبيه',
    //       'لم يتم إنشاء أسئلة جديدة، حاول تغيير إعدادات الصعوبة أو المادة.',
    //       backgroundColor: Colors.orange.shade100,
    //       colorText: Colors.orange.shade900,
    //     );
    //   } else {
    //     allQuestions.insertAll(0, generated);
    //     Get.snackbar(
    //       'تم',
    //       'تم إضافة ${generated.length} سؤالاً مقترحاً من الذكاء الاصطناعي.',
    //       backgroundColor: Colors.green.shade100,
    //       colorText: Colors.green.shade900,
    //     );
    //   }
    // } catch (e) {
    //   debugPrint('generateQuestionsByAI error: $e');
    //   Get.snackbar(
    //     'خطأ',
    //     'فشل توليد الأسئلة الذكية. تحقق من إعدادات Gemini أو الاتصال.',
    //     backgroundColor: Colors.red.shade100,
    //     colorText: Colors.red.shade900,
    //   );
    // } finally {
    //   isGeneratingQuestions.value = false;
    // }
  }

  List<QuestionModel> get selectedQuestions =>
      allQuestions.where((q) => selectedQuestionIds.contains(q.id)).toList();

  int get totalMarks => selectedQuestionIds.length;

  // ── حفظ الاختبار ─────────────────────────────────────────────────────────
  Future<void> saveExam() async {
    isSaving.value = true;
    try {
      final teacherId = _teacherId;
      final sectionId = selectedSectionId.value!;

      final total = totalMarks;
      final passing =
          ((int.tryParse(passingMarksController.text) ?? 50) / 100 * total)
              .round()
              .clamp(1, total);

      // ── 1. INSERT في exams ─────────────────────────────────────────────────
      final examRes = await _client
          .from('exams')
          .insert({
            'title': titleController.text.trim(),
            'description': descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim(),
            'subject_id': selectedSubjectId.value,
            'section_id': sectionId,
            'grade_id': selectedGradeId.value,
            'semester_id': selectedSemesterId.value,
            'total_marks': total,
            'passing_marks': passing,
            'duration_minutes': int.tryParse(durationController.text) ?? 30,
            'created_by_teacher': teacherId,
            'status': 'published',
          })
          .select('id')
          .single();

      final examId = examRes['id'] as int;

      // ── 2. INSERT في exam_questions ────────────────────────────────────────
      final questionsPayload = selectedQuestions
          .asMap()
          .entries
          .map(
            (entry) => {
              'exam_id': examId,
              'question_id': int.parse(entry.value.id),
              'question_order': entry.key + 1,
              'marks': 1,
            },
          )
          .toList();

      await _client.from('exam_questions').insert(questionsPayload);

      // ── 3. إسناد الاختبار ─────────────────────────────────────────────────
      if (isStudentMode) {
        // ── وضع الطالب الفردي → طالب واحد فقط ──────────────────────────────
        // الإشعار يُنشأ من قاعدة البيانات (trigger → notification_jobs → Edge worker).
        await _client.from('exam_assignments').insert({
          'exam_id': examId,
          'student_id': targetStudentId,
          'assigned_by': teacherId,
          'status': 'pending',
          'is_individual': true,
        });

        Get.back();
        Get.snackbar(
          'تم الإرسال ✅',
          '"${titleController.text.trim()}" — أُرسل إلى ${targetStudentName.value}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        // ── وضع الفصل → جميع الطلاب النشطين ────────────────────────────────
        final studentsRes = await _client
            .from('students')
            .select('id')
            .eq('section_id', sectionId)
            .eq('is_active', true);

        final studentIds = (studentsRes as List)
            .map((s) => s['id'] as int)
            .toList();

        if (studentIds.isNotEmpty) {
          final assignments = studentIds
              .map(
                (sid) => {
                  'exam_id': examId,
                  'student_id': sid,
                  'assigned_by': teacherId,
                  'status': 'pending',
                  'is_individual': false,
                },
              )
              .toList();

          await _client.from('exam_assignments').insert(assignments);
          debugPrint('✅ أُرسل لـ ${studentIds.length} طالب');
        } else {
          debugPrint('⚠️ لا يوجد طلاب في هذا الفصل');
        }

        Get.back();
        Get.snackbar(
          'تم إنشاء الاختبار ✅',
          studentIds.isNotEmpty
              ? '"${titleController.text.trim()}" — أُرسل لـ ${studentIds.length} طالب'
              : '"${titleController.text.trim()}" — لا يوجد طلاب في الفصل',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('saveExam error: $e');
      Get.snackbar(
        'خطأ',
        'فشل إنشاء الاختبار: $e',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  int get _teacherId =>
      int.parse(Get.find<AuthService>().currentUser.value!.id);

  String difficultyLabel(String d) {
    switch (d) {
      case 'easy':
        return 'سهل';
      case 'medium':
        return 'متوسط';
      case 'hard':
        return 'صعب';
      default:
        return d;
    }
  }

  Color difficultyColor(String d) {
    switch (d) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }
}
