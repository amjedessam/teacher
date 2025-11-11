// quiz_builder_binding.dart
import 'package:get/get.dart';
import 'quiz_builder_controller.dart';

class QuizBuilderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizBuilderController>(() => QuizBuilderController());
  }
}
