// // reports_controller.dart
// import 'package:get/get.dart';

// class ReportsController extends GetxController {
//   final selectedReportType = 0.obs;

//   void changeReportType(int index) {
//     selectedReportType.value = index;
//   }
// }

// reports_controller.dart
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
    Get.snackbar('قريباً', 'تقرير الفجوات المنهجية قريباً');
  }

  void openStrugglingStudents() {
    Get.snackbar('قريباً', 'تقرير الطلاب المتعثرين قريباً');
  }
}
