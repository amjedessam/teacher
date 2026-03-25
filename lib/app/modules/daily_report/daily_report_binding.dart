import 'package:get/get.dart';
import 'package:teacher/app/modules/daily_report/daily_report_controller.dart';

class DailyReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyReportController>(() => DailyReportController());
  }
}
