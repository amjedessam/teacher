import 'package:get/get.dart';
import 'reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsController>(() => ReportsController());
  }
}
