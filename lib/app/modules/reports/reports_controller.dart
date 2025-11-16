// import 'package:get/get.dart';
// import '../../routes/app_routes.dart';

// class ReportsController extends GetxController {
//   final selectedReportType = 0.obs;

//   void changeReportType(int index) {
//     selectedReportType.value = index;
//   }

//   void openClassReport() {
//     Get.toNamed(AppRoutes.classReport);
//   }

//   void openSubjectReport() {
//     Get.snackbar('قريباً', 'تقرير المادة قريباً');
//   }

//   void openCurriculumGaps() {
//     Get.snackbar('قريباً', 'تقرير الفجوات المنهجية قريباً');
//   }

//   void openStrugglingStudents() {
//     Get.snackbar('قريباً', 'تقرير الطلاب المتعثرين قريباً');
//   }
// }

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

  // ✅ تم تحديث: يفتح الصفحة الفعلية بدلاً من Snackbar
  void openCurriculumGaps() {
    Get.toNamed(AppRoutes.curriculumGaps);
  }

  void openStrugglingStudents() {
    Get.snackbar('قريباً', 'تقرير الطلاب المتعثرين قريباً');
  }
}
