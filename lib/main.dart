// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'app/core/theme/app_theme.dart';
// import 'app/routes/app_pages.dart';
// import 'app/data/services/storage_service.dart';
// import 'app/data/services/auth_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await GetStorage.init();

//   await _initServices();

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ),
//   );

//   runApp(const TeacherApp());
// }

// Future<void> _initServices() async {
//   print(' Starting services initialization...');

//   await Get.putAsync(() async {
//     final service = StorageService();
//     print(' StorageService initialized');
//     return service;
//   });

//   // تهيئة AuthService
//   await Get.putAsync(() async {
//     final service = AuthService();
//     service.onInit();
//     print('AuthService initialized');
//     return service;
//   });

//   print(' All services initialized successfully!');
// }

// class TeacherApp extends StatelessWidget {
//   const TeacherApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'تطبيق المعلم',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       initialRoute: AppPages.initial,
//       getPages: AppPages.routes,
//       defaultTransition: Transition.fade,
//       locale: const Locale('ar'),
//       fallbackLocale: const Locale('ar'),

//       builder: (context, child) {
//         return Directionality(textDirection: TextDirection.rtl, child: child!);
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/question_analysis_service.dart';
import 'app/data/services/curriculum_gap_analysis_service.dart';
import 'app/data/repositories/question_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await _initServices();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const TeacherApp());
}

Future<void> _initServices() async {
  print(' Starting services initialization...');

  await Get.putAsync(() async {
    final service = StorageService();
    print(' StorageService initialized');
    return service;
  });

  await Get.putAsync(() async {
    final service = AuthService();
    service.onInit();
    print(' AuthService initialized');
    return service;
  });

  await Get.putAsync<QuestionRepository>(() async {
    final repo = QuestionRepositoryImpl();

    print(' QuestionRepository initialized');
    return repo;
  });

  await Get.putAsync(() async {
    final service = QuestionAnalysisService();
    print(' QuestionAnalysisService initialized');
    return service;
  });

  await Get.putAsync(() async {
    final service = CurriculumGapAnalysisService();
    print(' CurriculumGapAnalysisService initialized');
    return service;
  });

  print(' All services initialized successfully!');
}

class TeacherApp extends StatelessWidget {
  const TeacherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'تطبيق المعلم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
