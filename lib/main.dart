
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/config/supabase_config.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/ai_service.dart';
import 'app/data/services/question_analysis_service.dart';
import 'app/data/repositories/question_repository.dart';
import 'app/data/repositories/classes_repository.dart';
import 'app/data/repositories/notifications_repository.dart';
import 'app/data/repositories/attendance_repository.dart';
import 'app/data/repositories/pending_content_repository.dart'
    hide QuestionRepository, QuestionRepositorySupabaseImpl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // استخدم الدالة الرسمية للمكتبة بدلاً من القراءة اليدوية
    await dotenv.load(fileName: ".env.example"); 
    debugPrint('✅ Loaded .env configuration');
  } catch (e) {
    debugPrint('⚠️ Error: $e');
  }

  // try {
  //   final envString = await rootBundle.loadString('.env.example');
  //   for (final line in envString.split('\n')) {
  //     if (line.isEmpty || line.startsWith('#')) continue;
  //     final index = line.indexOf('=');
  //     if (index > 0) {
  //       final key = line.substring(0, index);
  //       final value = line.substring(index + 1);
  //       dotenv.env[key] = value;
  //     }
  //   }
  //   debugPrint('✅ Loaded .env configuration');
  // } catch (e) {
  //   debugPrint('⚠️ .env file not found or failed to load: $e');
  // }

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

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
  print('🔧 Starting services initialization...');

  await Get.putAsync(() async {
    final service = StorageService();
    print('✅ StorageService initialized');
    return service;
  });

  await Get.putAsync(() async {
    final service = AuthService();
    service.onInit();
    print('✅ AuthService initialized');
    return service;
  });

  await Get.putAsync(() async {
    final service = AiService();
    print('✅ AiService initialized');
    return service;
  });

  await Get.putAsync<QuestionRepository>(() async {
    final repo = QuestionRepositorySupabaseImpl();
    print('✅ QuestionRepository (Supabase) initialized');
    return repo;
  });

  Get.put(ClassesRepository(), permanent: true);
  Get.put(NotificationsRepository(), permanent: true);
  Get.put(AttendanceRepository(), permanent: true);
  Get.put(PendingContentRepository(), permanent: true);
  print(
    '✅ ClassesRepository, NotificationsRepository, AttendanceRepository, PendingContentRepository initialized',
  );

  await Get.putAsync(() async {
    final service = QuestionAnalysisService();
    print('✅ QuestionAnalysisService initialized');
    return service;
  });

  // await Get.putAsync(() async {
  //   final service = CurriculumGapAnalysisService();
  //   print('✅ CurriculumGapAnalysisService initialized');
  //   return service;
  // });

  print('🚀 All services initialized successfully!');
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

      // ✅ إضافة دعم اللغة العربية الكامل
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // العربية - السعودية
        Locale('ar'), // العربية عامة
        Locale('en', 'US'), // الإنجليزية (احتياطي)
      ],
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar'),

      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
    );
  }
}
