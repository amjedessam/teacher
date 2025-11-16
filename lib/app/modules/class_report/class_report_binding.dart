import 'package:get/get.dart';
import 'class_report_controller.dart';

class ClassReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassReportController>(() => ClassReportController());
  }
}
