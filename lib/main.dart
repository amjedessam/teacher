// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'app/core/theme/app_theme.dart';
// import 'app/routes/app_pages.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Set preferred orientations
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // Set system UI overlay style
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

//       // RTL Support
//       builder: (context, child) {
//         return Directionality(textDirection: TextDirection.rtl, child: child!);
//       },
//     );
//   }
// }

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

//   // ✅ تهيئة GetStorage
//   await GetStorage.init();

//   // ✅ تهيئة الخدمات
//   await _initServices();

//   // Set preferred orientations
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // Set system UI overlay style
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

// /// تهيئة الخدمات الأساسية
// Future<void> _initServices() async {
//   print('🚀 Starting services initialization...');

//   // تهيئة StorageService
//   await Get.putAsync(() async {
//     final service = StorageService();
//     await service.onInit();
//     print('✅ StorageService initialized');
//     return service;
//   });

//   // تهيئة AuthService
//   await Get.putAsync(() async {
//     final service = AuthService();
//     service.onInit();
//     print('✅ AuthService initialized');
//     return service;
//   });

//   print('🎉 All services initialized successfully!');
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

//       // RTL Support
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة GetStorage
  await GetStorage.init();

  // ✅ تهيئة الخدمات
  await _initServices();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
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

/// تهيئة الخدمات الأساسية
Future<void> _initServices() async {
  print('🚀 Starting services initialization...');

  // تهيئة StorageService
  await Get.putAsync(() async {
    final service = StorageService();
    // ❌ تم حذف استدعاء onInit من هنا لأنه لم يعد موجودًا
    print('✅ StorageService initialized');
    return service;
  });

  // تهيئة AuthService
  await Get.putAsync(() async {
    final service = AuthService();
    service.onInit(); // هذا الاستدعاء صحيح ومطلوب
    print('✅ AuthService initialized');
    return service;
  });

  print('🎉 All services initialized successfully!');
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

      // RTL Support
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
