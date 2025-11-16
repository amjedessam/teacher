import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/mock_data_service.dart';
import '../../data/models/teacher_model.dart';
import '../../data/models/notification_model.dart';

class DashboardController extends GetxController {
  final AuthService _authService = Get.find();
  final mockDataService = MockDataService();

  final isLoading = true.obs;
  final teacher = Rxn<TeacherModel>();
  final dashboardStats = <String, dynamic>{}.obs;
  final notifications = <NotificationModel>[].obs;
  final unreadNotificationsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    teacher.value = _authService.currentUser.value;

    dashboardStats.value = mockDataService.getDashboardStats();
    notifications.value = mockDataService.getNotifications();

    _updateUnreadCount();

    isLoading.value = false;
  }

  void _updateUnreadCount() {
    unreadNotificationsCount.value = notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  List<double> get weeklyProgressData {
    if (dashboardStats['weeklyProgress'] != null) {
      return List<double>.from(
        dashboardStats['weeklyProgress'].map((e) => e.toDouble()),
      );
    }
    return [];
  }

  List<Map<String, dynamic>> get subjectPerformanceData {
    if (dashboardStats['subjectPerformance'] != null) {
      return List<Map<String, dynamic>>.from(
        dashboardStats['subjectPerformance'],
      );
    }
    return [];
  }
}
