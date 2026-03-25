import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

/// إرسال محتوى للمراجعة (سؤال أو امتحان) إلى pending_content.
class PendingContentRepository {
  SupabaseClient get _client => Supabase.instance.client;
  int? get _teacherId =>
      int.tryParse(Get.find<AuthService>().currentUser.value?.id ?? '');

  /// إرسال سؤال للموافقة (content_type = 'question'). content_data يُحدد حسب جدول questions.
  Future<bool> submitQuestion({
    required String questionText,
    required String questionType,
    required List<String> options,
    required int correctOptionIndex,
    required String difficulty,
    required int subjectId,
    String? explanation,
    int? chapterId,
  }) async {
    final tid = _teacherId;
    if (tid == null) return false;
    try {
      final correctAnswer =
          options.isNotEmpty &&
              correctOptionIndex >= 0 &&
              correctOptionIndex < options.length
          ? options[correctOptionIndex]
          : '';
      final optionsJson = options.map((o) => {'text': o}).toList();
      final contentData = {
        'question_text': questionText,
        'question_type': _mapQuestionType(questionType),
        'question_options': optionsJson,
        'correct_answer': correctAnswer,
        'difficulty_level': difficulty,
        'subject_id': subjectId,
        if (explanation != null && explanation.isNotEmpty)
          'explanation': explanation,
        if (chapterId != null) 'chapter_id': chapterId,
      };
      await _client.from('pending_content').insert({
        'content_type': 'question',
        'content_data': contentData,
        'teacher_id': tid,
        'status': 'pending',
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  String _mapQuestionType(String type) {
    switch (type.toLowerCase()) {
      case 'mcq':
        return 'multiple_choice';
      case 'true_false':
        return 'true_false';
      case 'essay':
        return 'essay';
      case 'fill_blank':
        return 'fill_blank';
      default:
        return 'multiple_choice';
    }
  }
}
