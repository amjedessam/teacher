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
  Future<void> addQuestion(QuestionModel question) async => Future.value();

  @override
  Future<void> updateQuestion(QuestionModel question) async => Future.value();

  @override
  Future<void> deleteQuestion(String id) async => Future.value();

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
