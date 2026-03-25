import 'package:get/get.dart';
import 'question_quality_controller.dart';

class QuestionQualityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionQualityController>(() => QuestionQualityController());
  }
}

// import 'package:get/get.dart';
// import '../../../app/data/repositories/question_repository.dart';
// import '../../../app/data/services/question_analysis_service.dart';
// import 'question_quality_controller.dart';

// class QuestionQualityBinding extends Bindings {
//   @override
//   void dependencies() {
//     // 1. تهيئة الـ Repository (باستخدام الـ Mock حالياً)
//     Get.lazyPut<QuestionRepository>(() => QuestionRepositoryImpl());

//     // 2. تهيئة خدمة التحليل (تعتمد على الـ Repository)
//     Get.lazyPut<QuestionAnalysisService>(() => QuestionAnalysisService());

//     // 3. تهيئة الـ Controller
//     Get.lazyPut<QuestionQualityController>(
//       () => QuestionQualityController(
//         analysisService: Get.find<QuestionAnalysisService>(),
//       ),
//     );
//   }
// }
