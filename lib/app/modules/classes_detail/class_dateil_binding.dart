import 'package:get/get.dart';
import 'class_detail_controller.dart';

class ClassDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassDetailController>(() => ClassDetailController());
  }
}
