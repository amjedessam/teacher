// add_question_binding.dart
import 'package:get/get.dart';
import 'add_question_controller.dart';

class AddQuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddQuestionController>(() => AddQuestionController());
  }
}
