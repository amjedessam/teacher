import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher/app/data/repositories/classes_repository.dart';
import 'package:teacher/app/data/services/auth_service.dart';

// ── نموذج الفصل المختار ──────────────────────────────────────────────────────
class SectionSubjectOption {
  final int sectionId;
  final String sectionName;
  final int subjectId;
  final String subjectName;

  SectionSubjectOption({
    required this.sectionId,
    required this.sectionName,
    required this.subjectId,
    required this.subjectName,
  });

  String get displayName => '$sectionName — $subjectName';
}

class DailyReportController extends GetxController {
  SupabaseClient get _client => Supabase.instance.client;

  // ── الفصول المتاحة ────────────────────────────────────────────────────────
  final sectionOptions = <SectionSubjectOption>[].obs;
  final selectedOption = Rxn<SectionSubjectOption>();
  final isLoadingSections = false.obs;

  // ── Tab: 0 = نشاط/واجب  |  1 = خلاصة يومية ───────────────────────────────
  final selectedTab = 0.obs;

  // ── Activity Form ─────────────────────────────────────────────────────────
  final activityTitleController = TextEditingController();
  final activityDescController = TextEditingController();
  final selectedActivityType = 'homework'.obs;
  final selectedPriority = 3.obs;
  final selectedDueDate = Rxn<DateTime>();
  final isSavingActivity = false.obs;

  // ── Daily Summary Form ────────────────────────────────────────────────────
  final recapController = TextEditingController();
  final highlightController = TextEditingController();
  final selectedPerformance = 'good'.obs;
  final participationLevel = 3.obs;
  final behaviorLevel = 3.obs;
  final focusLevel = 3.obs;
  final isSavingSummary = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSections();
  }

  @override
  void onClose() {
    activityTitleController.dispose();
    activityDescController.dispose();
    recapController.dispose();
    highlightController.dispose();
    super.onClose();
  }

  // ── جلب الفصول والمواد ────────────────────────────────────────────────────
  Future<void> _loadSections() async {
    isLoadingSections.value = true;
    try {
      final repo = Get.find<ClassesRepository>();
      final list = await repo.getAssignedClasses();

      final options = list.where((c) => c.subjectId != null).map((c) {
        // ✅ تحديد sectionId بشكل آمن
        int parsedSectionId;
        if (c.id is int) {
          parsedSectionId = c.id as int;
        } else if (c.id is String) {
          // إذا كان String يحتوي على _ فنقسمه، وإلا نحوله مباشرة
          final idString = c.id as String;
          if (idString.contains('_')) {
            parsedSectionId = int.parse(idString.split('_')[0]);
          } else {
            parsedSectionId = int.parse(idString);
          }
        } else {
          throw Exception('Invalid section ID type: ${c.id.runtimeType}');
        }

        return SectionSubjectOption(
          sectionId: parsedSectionId,
          sectionName: c.name,
          subjectId: c.subjectId!,
          subjectName: c.subject,
        );
      }).toList();

      sectionOptions.value = options;

      // ✅ تعيين القيمة الافتراضية فقط إذا كانت القائمة غير فارغة
      if (options.isNotEmpty) {
        selectedOption.value = options.first;
      } else {
        selectedOption.value = null;
        // ✅ إظهار رسالة للمستخدم
        Get.snackbar(
          'تنبيه',
          'لا توجد فصول مسندة لك حالياً',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('_loadSections error: $e');
      sectionOptions.value = [];
      selectedOption.value = null;
      Get.snackbar(
        'خطأ',
        'فشل تحميل الفصول: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSections.value = false;
    }
  }

  // ── اختيار تاريخ التسليم ──────────────────────────────────────────────────
  Future<void> pickDueDate() async {
    final context = Get.context;
    if (context == null) {
      Get.snackbar('خطأ', 'لا يمكن فتح منتقي التاريخ');
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (picked != null) selectedDueDate.value = picked;
  }

  // ── حفظ النشاط للفصل كامل ────────────────────────────────────────────────
  Future<void> saveActivity() async {
    // ✅ التحقق من وجود فصل مختار أولاً
    if (selectedOption.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الفصل والمادة أولاً');
      return;
    }

    if (activityTitleController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال عنوان النشاط');
      return;
    }

    if (selectedDueDate.value == null) {
      Get.snackbar('خطأ', 'يرجى تحديد تاريخ التسليم');
      return;
    }

    isSavingActivity.value = true;
    try {
      final option = selectedOption.value!;
      final teacherId = _teacherId;

      // جلب جميع طلاب الفصل
      final studentsRes = await _client
          .from('students')
          .select('id')
          .eq('section_id', option.sectionId)
          .eq('is_active', true);

      final studentIds = (studentsRes as List)
          .map((s) => s['id'] as int)
          .toList();

      if (studentIds.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا يوجد طلاب في هذا الفصل',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
        return;
      }

      // INSERT لكل طالب
      final payload = studentIds
          .map(
            (sid) => {
              'student_id': sid,
              'title': activityTitleController.text.trim(),
              'description': activityDescController.text.trim().isEmpty
                  ? null
                  : activityDescController.text.trim(),
              'subject_id': option.subjectId,
              'activity_type': selectedActivityType.value,
              'priority': selectedPriority.value,
              'due_date': selectedDueDate.value!
                  .toIso8601String()
                  .split('T')
                  .first,
              'status': 'pending',
              'created_by_teacher_id': teacherId,
              'section_id': option.sectionId,
              'is_class_activity': true,
            },
          )
          .toList();

      await _client.from('activities').insert(payload);

      // Reset form
      activityTitleController.clear();
      activityDescController.clear();
      selectedDueDate.value = null;
      selectedPriority.value = 3;
      selectedActivityType.value = 'homework';

      Get.snackbar(
        'تم الإرسال ✅',
        'أُرسل النشاط لـ ${studentIds.length} طالب',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('saveActivity error: $e');
      Get.snackbar(
        'خطأ',
        'فشل إرسال النشاط: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isSavingActivity.value = false;
    }
  }

  // ── حفظ الخلاصة اليومية للفصل كامل ──────────────────────────────────────
  Future<void> saveDailySummary() async {
    // ✅ التحقق من وجود فصل مختار أولاً
    if (selectedOption.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الفصل والمادة أولاً');
      return;
    }

    if (recapController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'يرجى كتابة ملخص الحصة');
      return;
    }
    isSavingSummary.value = true;
    try {
      final option = selectedOption.value!;
      final teacherId = _teacherId;
      final today = DateTime.now().toIso8601String().split('T').first;

      // جلب جميع طلاب الفصل
      final studentsRes = await _client
          .from('students')
          .select('id')
          .eq('section_id', option.sectionId)
          .eq('is_active', true);

      final studentIds = (studentsRes as List)
          .map((s) => s['id'] as int)
          .toList();

      if (studentIds.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا يوجد طلاب في هذا الفصل',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
        return;
      }

      // UPSERT لكل طالب (يحدّث إذا موجود ليوم اليوم)
      final payload = studentIds
          .map(
            (sid) => {
              'student_id': sid,
              'summary_date': today,
              'recap': recapController.text.trim(),
              'overall_performance': selectedPerformance.value,
              'participation_level': participationLevel.value.toString(),
              'behavior_level': behaviorLevel.value.toString(),
              'focus_level': focusLevel.value.toString(),
              'highlight_of_day': highlightController.text.trim().isEmpty
                  ? null
                  : highlightController.text.trim(),
              'subjects_studied': [option.subjectName],
              'created_by_teacher_id': teacherId,
              'section_id': option.sectionId,
              'subject_id': option.subjectId,
            },
          )
          .toList();

      await _client
          .from('daily_summaries')
          .upsert(payload, onConflict: 'student_id,summary_date');

      // Reset form
      recapController.clear();
      highlightController.clear();
      selectedPerformance.value = 'good';
      participationLevel.value = 3;
      behaviorLevel.value = 3;
      focusLevel.value = 3;

      Get.snackbar(
        'تم الإرسال ✅',
        'أُرسلت الخلاصة لـ ${studentIds.length} طالب',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      debugPrint('saveDailySummary error: $e');
      Get.snackbar(
        'خطأ',
        'فشل إرسال الخلاصة: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isSavingSummary.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  int get _teacherId =>
      int.parse(Get.find<AuthService>().currentUser.value!.id);

  String activityTypeLabel(String type) {
    switch (type) {
      case 'homework':
        return 'واجب منزلي';
      case 'project':
        return 'مشروع';
      case 'reading':
        return 'قراءة';
      case 'practice':
        return 'تمرين';
      default:
        return type;
    }
  }

  String performanceLabel(String p) {
    switch (p) {
      case 'excellent':
        return 'ممتاز';
      case 'good':
        return 'جيد';
      case 'average':
        return 'متوسط';
      case 'poor':
        return 'ضعيف';
      default:
        return p;
    }
  }

  Color performanceColor(String p) {
    switch (p) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'average':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
