import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/question_model.dart';

class AiService extends GetxService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _model =
      'gemini-1.5-flash'; //'gemini-1.5-flash-8b';//'gemini-flash-latest';

  bool get isConfigured => _apiKey.isNotEmpty;

  String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  Future<List<QuestionModel>> generateQuestions({
    required String subject,
    String? chapter,
    String difficulty = 'medium',
    String questionType = 'mcq',
    int count = 4,
  }) async {
    if (!isConfigured) {
      throw StateError(
        'GEMINI_API_KEY is not configured. ضع المفتاح في ملف .env',
      );
    }

    final prompt = _buildQuestionPrompt(
      subject: subject,
      chapter: chapter,
      difficulty: difficulty,
      questionType: questionType,
      count: count,
    );

    final raw = await _generateContent(prompt);
    final jsonString = _extractJson(raw);
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw FormatException('توقعت مصفوفة من الأسئلة، لكن الاستجابة مختلفة');
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final questions = <QuestionModel>[];

    for (var i = 0; i < decoded.length; i++) {
      final item = decoded[i];
      if (item is! Map<String, dynamic>) continue;

      final options = <QuestionOption>[];
      final rawOptions = item['options'];
      if (rawOptions is List) {
        for (var j = 0; j < rawOptions.length; j++) {
          final opt = rawOptions[j];
          if (opt is Map<String, dynamic>) {
            options.add(
              QuestionOption(
                // توليد معرّف رقمي بدلاً من نصي يبدأ بحرف
                id:  '${j + 1}',
                text: opt['text']?.toString() ?? '',
                isCorrect:
                    opt['isCorrect'] == true ||
                    opt['isCorrect']?.toString().toLowerCase() == 'true',
              ),
            );
          }
        }
      }

      questions.add(
        QuestionModel(
          //id: '${now}_$i',
          id: (now + i).toString(), // ينتج رقماً فريداً كنص بدون علامات
          questionText: item['questionText']?.toString() ?? '',
          questionType: item['questionType']?.toString() ?? questionType,
          options: options,
          correctAnswer: item['correctAnswer']?.toString() ?? '',
          explanation: item['explanation']?.toString() ?? '',
          difficulty: item['difficulty']?.toString() ?? difficulty,
          cognitiveSkill: item['cognitiveSkill']?.toString() ?? 'understand',
          subject: subject,
          subjectId: '',
          chapter: chapter ?? '',
          unit: '',
          timesUsed: 0,
          timesCorrect: 0,
          timesIncorrect: 0,
          difficultyIndex: 0.5,
          discriminationIndex: 0.3,
          quality: 'غير معتمد',
          isApproved: false,
          createdAt: DateTime.now(),
        ),
      );
    }

    return questions;
  }

  Future<String> summarizeQuestionBankQuality(
    Map<String, dynamic> qualityStats,
  ) async {
    if (!isConfigured) {
      throw StateError(
        'GEMINI_API_KEY is not configured. ضع المفتاح في ملف .env',
      );
    }

    final prompt =
        '''
أنت مساعد تحليل تعليمي باللغة العربية. لديك إحصائيات جودة بنك الأسئلة التالية:

- العدد الكلي: ${qualityStats['total'] ?? 0}
- ممتاز: ${qualityStats['excellent'] ?? 0}
- جيد: ${qualityStats['good'] ?? 0}
- مقبول: ${qualityStats['fair'] ?? 0}
- يحتاج مراجعة: ${qualityStats['needsReview'] ?? 0}
- نسبة ممتاز: ${qualityStats['excellentPercentage']?.toStringAsFixed(1) ?? '0.0'}%
- نسبة يحتاج مراجعة: ${qualityStats['needsReviewPercentage']?.toStringAsFixed(1) ?? '0.0'}%

أعط توصية عملية للمعلم في فقرة قصيرة باللغة العربية، مع اقتراحين لتحسين بنك الأسئلة أو المراجعة. لا تذكر التنسيق JSON.
''';

    return _generateContent(prompt);
  }

  String _buildQuestionPrompt({
    required String subject,
    String? chapter,
    required String difficulty,
    required String questionType,
    required int count,
  }) {
    final chapterText = chapter != null && chapter.isNotEmpty
        ? 'في الفصل أو الوحدة التالية: $chapter'
        : 'بدون تحديد للفصل أو الوحدة';

    return '''
أنت مساعد تعليمي متخصص في إنشاء أسئلة تقييم باللغة العربية. أرجو أن تخرج نتيجة واحدة فقط بصيغة JSON صالحة ONLY JSON FORMAT NO OTHER TEXT.

المطلوب:
- أنشئ $count سؤالاً من نوع ${questionType == 'mcq' ? 'اختيار من متعدد' : questionType}.
- المادة: $subject.
- $chapterText.
- مستوى الصعوبة: ${difficulty == 'easy'
        ? 'سهل'
        : difficulty == 'hard'
        ? 'صعب'
        : 'متوسط'}.
- استخدم أسئلة باللغة العربية الفصحى.
- لكل سؤال قدم 4 خيارات على الأقل في حال كان اختيار متعدد.
- حدد الإجابة الصحيحة في المفتاح الصحيح.
- اذكر شرحاً قصيراً لكل سؤال.
- اجعل نوع المهارة العقلية واحداً من: remember, understand, apply, analyze.
-اجعل الشرح مختصراً جداً لضمان اكتمال الرد.
الرجاء إخراج JSON فقط بالشكل التالي:
[
  {
    "questionText": "...",
    "questionType": "mcq",
    "options": [
      {"id": "A", "text": "...", "isCorrect": true},
      ...
    ],
    "correctAnswer": "...",
    "explanation": "...",
    "difficulty": "easy|medium|hard",
    "cognitiveSkill": "remember|understand|apply|analyze"
  }
]
''';
  }

  Future<String> _generateContent(String prompt) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json', 'X-goog-api-key': _apiKey},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7, // رفع الحرارة قليلاً للإبداع
          'maxOutputTokens': 4096, // زيادة المساحة للنص العربي
          'topP': 0.95,
          // تفعيل وضع الـ JSON إذا كان الموديل يدعمه
          'responseMimeType': 'application/json',
        },
      }),
    );

    if (response.statusCode != 200) {
      throw http.ClientException(
        'Failed to call Gemini API: ${response.statusCode} ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    final candidates = body['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw FormatException('لم يتم استلام بيانات من الذكاء الاصطناعي');
    }

    final content = candidates.first['content']?['parts']?.first['text']
        ?.toString();

    if (content == null || content.isEmpty) {
      throw FormatException('محتوى الاستجابة فارغ');
    }

    return content;
  }

  // Future<String> _generateContent(String prompt) async {
  //   final response = await http.post(
  //     Uri.parse(_endpoint),
  //     headers: {'Content-Type': 'application/json', 'X-goog-api-key': _apiKey},
  //     body: jsonEncode({
  //       'contents': [
  //         {
  //           'parts': [
  //             {'text': prompt},
  //           ],
  //         },
  //       ],
  //       'generationConfig': {
  //         'temperature': 0.6,
  //         'maxOutputTokens': 900,
  //         'topP': 0.95,
  //       },
  //     }),
  //   );

  //   if (response.statusCode != 200) {
  //     throw http.ClientException(
  //       'Failed to call Gemini API: ${response.statusCode} ${response.body}',
  //     );
  //   }

  //   final body = jsonDecode(response.body) as Map<String, dynamic>;
  //   final content = (body['candidates'] as List?)
  //       ?.firstOrNull?['content']?['parts']
  //       ?.firstOrNull?['text']
  //       ?.toString();
  //   if (content == null || content.isEmpty) {
  //     throw FormatException('لم يتم استلام نص من خدمة Gemini الذكية.');
  //   }

  //   return content;
  // }

  String _extractJson(String raw) {
    final start = raw.indexOf('[');
    final end = raw.lastIndexOf(']');
    if (start >= 0 && end > start) {
      return raw.substring(start, end + 1);
    }
    return raw;
  }
}
