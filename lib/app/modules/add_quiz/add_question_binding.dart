import 'package:get/get.dart';
import 'add_question_controller.dart';

class AddQuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddQuestionController>(() => AddQuestionController());
  }
}
