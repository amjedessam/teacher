import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/data/services/auth_service.dart';
import '../models/question_model.dart';

abstract class QuestionRepository {
  Future<List<QuestionModel>> getQuestions({
    String? difficulty,
    String? subjectId,
  });
  Future<QuestionModel?> getQuestionById(String id);
  Future<void> addQuestion(QuestionModel question);
  Future<void> updateQuestion(QuestionModel question);
  Future<void> deleteQuestion(String id);
  Future<void> updateQuestionStatistics({
    required String questionId,
    required bool wasCorrect,
    required double studentTotalScore,
  });
  Future<List<QuestionModel>> getQuestionsByQuality(String quality);
  Future<List<QuestionModel>> getSuspiciousQuestions();
}

class QuestionRepositorySupabaseImpl implements QuestionRepository {
  SupabaseClient get _client => Supabase.instance.client;

  int get _teacherId =>
      int.parse(Get.find<AuthService>().currentUser.value!.id);

  // ══════════════════════════════════════════════════════════════
  // getQuestions — يستخدم RPC مع إحصائيات حقيقية
  // ══════════════════════════════════════════════════════════════
  @override
  Future<List<QuestionModel>> getQuestions({
    String? difficulty,
    String? subjectId,
  }) async {
    try {
      final data = await _client.rpc(
        'get_teacher_questions_with_stats',
        params: {'p_teacher_id': _teacherId},
      );

      final list = (data as List).cast<Map<String, dynamic>>();

      var models = list.map((row) => QuestionModel.fromRpcRow(row)).toList();

      // فلترة محلية
      if (difficulty != null && difficulty.isNotEmpty) {
        models = models.where((q) => q.difficulty == difficulty).toList();
      }
      if (subjectId != null && subjectId.isNotEmpty) {
        models = models.where((q) => q.subjectId == subjectId).toList();
      }

      return models;
    } catch (e) {
      debugPrint('getQuestions error: $e');
      return [];
    }
  }

  @override
  Future<QuestionModel?> getQuestionById(String id) async {
    try {
      final res = await _client
          .from('questions')
          .select('*, subjects(name)')
          .eq('id', int.tryParse(id) ?? 0)
          .maybeSingle();
      if (res == null) return null;
      return QuestionModel.fromQuestionRow(Map<String, dynamic>.from(res));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addQuestion(QuestionModel question) async {
    try {
      final optionsJson = question.options
          .map((o) => {'id': o.id, 'text': o.text, 'is_correct': o.isCorrect})
          .toList();

      await _client.from('questions').insert({
        'question_text': question.questionText,
        'question_type': question.questionType,
        'question_options': optionsJson,
        'correct_answer': question.correctAnswer,
        'explanation': question.explanation.isEmpty
            ? null
            : question.explanation,
        'difficulty_level': question.difficulty,
        'skill': question.cognitiveSkill.isEmpty
            ? null
            : question.cognitiveSkill,
        'subject_id': int.tryParse(question.subjectId) ?? null,
        'chapter_id': int.tryParse(question.chapter) ?? null,
        'unit': int.tryParse(question.unit) ?? null,
        'is_active': true,
        'status': 'approved',
        'created_by_teacher': int.tryParse(
          Get.find<AuthService>().currentUser.value!.id,
        ),
        'times_used': 0,
        'times_correct': 0,
        'times_incorrect': 0,
      });
    } catch (e) {
      debugPrint('addQuestion error: $e');
    }
  }

  @override
  Future<void> updateQuestion(QuestionModel question) async {
    try {
      final optionsJson = question.options
          .map((o) => {'id': o.id, 'text': o.text, 'is_correct': o.isCorrect})
          .toList();

      await _client
          .from('questions')
          .update({
            'question_text': question.questionText,
            'question_type': question.questionType,
            'question_options': optionsJson,
            'correct_answer': question.correctAnswer,
            'explanation': question.explanation.isEmpty
                ? null
                : question.explanation,
            'difficulty_level': question.difficulty,
            'skill': question.cognitiveSkill.isEmpty
                ? null
                : question.cognitiveSkill,
            'chapter_id': int.tryParse(question.chapter) ?? null,
            'unit': int.tryParse(question.unit) ?? null,
            'is_active': true,
          })
          .eq('id', int.tryParse(question.id) ?? 0);
    } catch (e) {
      debugPrint('updateQuestion error: $e');
    }
  }

  @override
  Future<void> deleteQuestion(String id) async {
    try {
      await _client.from('questions').delete().eq('id', int.tryParse(id) ?? 0);
    } catch (e) {
      debugPrint('deleteQuestion error: $e');
    }
  }

  @override
  Future<void> updateQuestionStatistics({
    required String questionId,
    required bool wasCorrect,
    required double studentTotalScore,
  }) async {
    try {
      final q = await getQuestionById(questionId);
      if (q == null) return;
      await _client
          .from('questions')
          .update({
            'times_used': q.timesUsed + 1,
            'times_correct': q.timesCorrect + (wasCorrect ? 1 : 0),
            'times_incorrect': q.timesIncorrect + (wasCorrect ? 0 : 1),
          })
          .eq('id', int.parse(questionId));
    } catch (_) {}
  }

  @override
  Future<List<QuestionModel>> getQuestionsByQuality(String quality) async {
    final all = await getQuestions();
    return all.where((q) => q.quality == quality).toList();
  }

  @override
  Future<List<QuestionModel>> getSuspiciousQuestions() async {
    final all = await getQuestions();
    return all
        .where(
          (q) => q.quality == 'يحتاج مراجعة' || q.quality == 'لم يُستخدم بعد',
        )
        .toList();
  }
}
