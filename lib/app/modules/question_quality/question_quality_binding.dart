import 'package:get/get.dart';
import 'question_quality_controller.dart';

class QuestionQualityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionQualityController>(() => QuestionQualityController());
  }
}
