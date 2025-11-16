import 'package:get/get.dart';
import 'curriculum_gaps_controller.dart';

class CurriculumGapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurriculumGapsController>(() => CurriculumGapsController());
  }
}
