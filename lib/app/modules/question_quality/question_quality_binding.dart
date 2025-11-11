// // question_quality_binding.dart
// import 'package:get/get.dart';
// import 'question_quality_controller.dart';

// class QuestionQualityBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<QuestionQualityController>(() => QuestionQualityController());
//   }
// }

// question_quality_binding.dart
import 'package:get/get.dart';
import 'question_quality_controller.dart';

class QuestionQualityBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => QuestionQualityController());
    Get.lazyPut<QuestionQualityController>(() => QuestionQualityController());
  }
}
