
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teacher/app/data/models/gapModel.dart';

class AiService  {
  final Dio _dio = Dio();

  AiService() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }






  static Future<List<ChapterGap>> analyzeCurriculumGapsWithAI(Map<String, dynamic> rawData) async {
    // 1. تجهيز البيانات الخام من الكونترولر (الدالة التي كتبناها سابقاً)
    //final Map<String, dynamic> rawData = generateAIAnalysisData();
    final String jsonData = jsonEncode(rawData);

    final prompt = '''
أنت خبير تربوي ومحلل بيانات تعليمية. قم بتحليل بيانات الفصل التالية واكتشاف "الفجوات المنهجية" (Curriculum Gaps).
الهدف هو تحديد المواضيع التي يواجه فيها الطلاب صعوبة وتقديم توصيات للمعلم.

يجب أن يكون الرد بصيغة JSON فقط بالهيكل التالي:
{
  "curriculum_gaps": [
    {
      "id": "معرف الفصل أو الاختبار",
      "chapter_name": "اسم الموضوع أو الفصل الدراسي",
      "subject_name": "اسم المادة",
      "avg_failure_rate": 0.0, // نسبة الفشل المئوية المتوقعة بناءً على البيانات
      "severity": "critical", // الاختيارات: critical, high, medium, low
      "ai_recommendation": "نصيحة تعليمية محددة للمعلم للتعامل مع هذه الفجوة",
      "questions": [
        {
          "question_text": "نص السؤال الذي سجل أعلى معدل خطأ",
          "total_students": 0,
          "failed_students": 0,
          "failure_rate": 0.0,
          "severity": "high" // مستوى خطورة السؤال
        }
      ]
    }
  ]
}

البيانات المرجعية للتحليل:
$jsonData

ملاحظة: 
- اعتمد في تقييم (severity) على معدلات الفشل والدرجات الدنيا.
- اجعل التوصيات عمليّة (مثلاً: "أعد شرح قاعدة X باستخدام الوسائل البصرية").
- تأكد أن جميع النصوص باللغة العربية مع الحفاظ على مفاتيح (Keys) الـ JSON بالإنجليزية.
''';

    try {
      // 2. إرسال الطلب للموديل (بناءً على نظام AIChat الخاص بك)
      final response = await AIChat().getAIResponse(prompt);
      
      // 3. فك تشفير الاستجابة (بناءً على دالتك _decodeAIResponse)
      final resultJson = _decodeAIResponse(response);

      if (resultJson is! Map<String, dynamic> || resultJson['curriculum_gaps'] == null) {
        throw Exception('Invalid AI Response structure');
      }

      // 4. تحويل JSON إلى قائمة من كائنات ChapterGap
      final List gapsList = resultJson['curriculum_gaps'] as List;
      
      return gapsList.map((item) => ChapterGap.fromJson(Map<String, dynamic>.from(item))).toList();

    } catch (e) {
      debugPrint('Error in analyzeCurriculumGapsWithAI: $e');
      rethrow;
    }
  }




  static _decodeAIResponse(String response) {
    if (response.startsWith('Error from Server:') || response.startsWith('Exception:')) {
      final errorBodyStart = response.indexOf('{');
      if (errorBodyStart != -1) {
        final errorJson = response.substring(errorBodyStart);
        try {
          final decoded = jsonDecode(errorJson);
          if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
            final error = decoded['error'];
            final message = error is Map<String, dynamic>
                ? error['message'] ?? error.toString()
                : error.toString();
            throw Exception('AI API error: $message');
          }
        } catch (_) {
          throw Exception(response);
        }
      }
      throw Exception(response);
    }

    final cleanJson = _extractJson(response);
    try {
      final decoded = jsonDecode(cleanJson);
      if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
        final error = decoded['error'];
        final message = error is Map<String, dynamic>
            ? error['message'] ?? error.toString()
            : error.toString();
        throw Exception('AI API error: $message');
      }
      return decoded;
    } on FormatException catch (e) {
      throw Exception('Unable to decode AI response as JSON: ${e.message}\nResponse: $response');
    }
  }
 static String _extractJson(String text) {
  try {
    // البحث عن بداية ونهاية الـ JSON الحقيقية
    int startIndex = text.indexOf('{');
    int endIndex = text.lastIndexOf('}');
    
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return text.substring(startIndex, endIndex + 1);
    }
  } catch (e) {
    print("Extraction Error: $e");
  }
  return text.trim();
}

  

}


class AIConfig {

  static final String geminiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String geminiUrl = dotenv.env['GEMINI_URL'] ?? '';
  static final String geminiModel = dotenv.env['GEMINI_MODEL'] ?? '';
}
class AIChat {
  final Dio _dio = Dio();

  Future<String> getAIResponse(String prompt) async {
    String url = '';
    dynamic body;
    Options options = Options(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status! < 500, // يسمح بمرور الخطأ 400 لمعرفته بدلاً من الانهيار
    );

    try {
       url = '${AIConfig.geminiUrl}?key=${AIConfig.geminiKey}';
        body = {
          "contents": [
            {
              "parts": [{"text": prompt}]
            }
          ]
        };
      

      final response = await _dio.post(url, data: body, options: options);

      // فحص إذا كان السيرفر أرجع خطأ 400 أو 404
      if (response.statusCode != 200) {
        return "Error from Server: ${response.statusCode} - ${response.data}";
      }
       
       return response.data['candidates'][0]['content']['parts'][0]['text'];
      // استخراج النص الصحيح بناءً على الموديل
      
    } catch (e) {
      return "Exception: $e";
    }
  }
}