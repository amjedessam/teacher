import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ReportsController extends GetxController {
  final selectedReportType = 0.obs;

  void changeReportType(int index) {
    selectedReportType.value = index;
  }

  void openClassReport() {
    Get.toNamed(AppRoutes.classReport);
  }

  void openSubjectReport() {
    Get.snackbar('قريباً', 'تقرير المادة قريباً');
  }

  void openCurriculumGaps() {
    Get.toNamed(AppRoutes.curriculumGaps);
  }

  // ✅ الخلاصة اليومية + النشاط/الواجب
  void openDailyReport() {
    Get.toNamed(AppRoutes.dailyReport);
  }

  // ✅ ملاحظة لطالب معين — تُفتح من تفاصيل الطالب مباشرة
  void openStudentNote() {
    Get.snackbar('تنبيه', 'افتح من تفاصيل الطالب مباشرة');
  }
}
