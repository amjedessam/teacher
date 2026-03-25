import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher/app/modules/add_quiz/add_question_binding.dart';
import 'package:teacher/app/modules/add_quiz/add_question_view.dart';
import 'package:teacher/app/modules/class_report/class_report_controller.dart';
import 'package:teacher/app/modules/classes_detail/class_dateil_binding.dart';
import 'package:teacher/app/modules/classes_detail/class_detail_viwe.dart';
import 'package:teacher/app/modules/classes_detail/exam_detail_view.dart';
import 'package:teacher/app/modules/curriculum_gaps/curriculum_gaps_binding.dart';
import 'package:teacher/app/modules/curriculum_gaps/curriculum_gaps_view.dart';
import 'package:teacher/app/modules/daily_report/daily_report_binding.dart';
import 'package:teacher/app/modules/daily_report/daily_report_view.dart';
import 'package:teacher/app/modules/question_bank/question_bank_binding.dart';
import 'package:teacher/app/modules/question_bank/question_bank_view.dart';
import 'package:teacher/app/modules/quiz_builder/quiz_builder_controller.dart';
import 'package:teacher/app/modules/student_detail/student_detail_binding.dart';
import 'package:teacher/app/modules/student_detail/student_detail_view.dart';
import 'package:teacher/app/modules/student_exam_detail/student_exam_detail_view.dart';
import 'package:teacher/app/modules/student_note/student_note_binding.dart';
import 'package:teacher/app/modules/student_note/student_note_view.dart';

import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/main_navigation/main_navigation_binding.dart';
import '../modules/main_navigation/main_navigation_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/students/students_binding.dart';
import '../modules/students/students_view.dart';
import '../modules/classes/classes_binding.dart';
import '../modules/classes/classes_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/quiz_builder/quiz_builder_binding.dart';
import '../modules/quiz_builder/quiz_builder_view.dart';
import '../modules/reports/reports_binding.dart';
import '../modules/reports/reports_view.dart';
import '../modules/question_quality/question_quality_binding.dart';
import '../modules/question_quality/question_quality_view.dart';
import '../modules/notifications/notifications_binding.dart';
import '../modules/notifications/notifications_view.dart';
import '../modules/class_report/class_report_binding.dart';
import '../modules/class_report/class_report_view.dart';
import '../modules/attendance/attendance_binding.dart';
import '../modules/attendance/attendance_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.mainNavigation,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.classes,
      page: () => const ClassesView(),
      binding: ClassesBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoutes.classDetail,
      page: () => const ClassDetailView(),
      binding: ClassDetailBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    // ✅ شاشة تفاصيل الاختبار — لا تحتاج binding
    GetPage(
      name: AppRoutes.examDetail,
      page: () => const ExamDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.studentExamDetail,
      page: () => const StudentExamDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.students,
      page: () => const StudentsView(),
      binding: StudentsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoutes.studentDetail,
      page: () => const StudentDetailView(),
      binding: StudentDetailBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.questionBank,
      page: () => const QuestionBankView(),
      binding: QuestionBankBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.addQuestion,
      page: () => const AddQuestionView(),
      binding: AddQuestionBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.questionQuality,
      page: () => const QuestionQualityView(),
      binding: QuestionQualityBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.classReport,
      page: () => const ClassReportView(),
      binding: ClassReportBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
      transitionDuration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.quizBuilder,
      page: () => const QuizBuilderView(),
      binding: QuizBuilderBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.curriculumGaps,
      page: () => const CurriculumGapsView(),
      binding: CurriculumGapsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    ),
    GetPage(
      name: AppRoutes.dailyReport,
      page: () => const DailyReportView(),
      binding: DailyReportBinding(),
    ),
    GetPage(
      name: AppRoutes.studentNote,
      page: () => const StudentNoteView(),
      binding: StudentNoteBinding(),
    ),
  ];
}
