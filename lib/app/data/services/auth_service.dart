import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/teacher_model.dart';

/// خدمة المصادقة عبر Supabase Auth.
/// المدير ينشئ حسابات المعلمين في Supabase Auth وربطها في app_user + teachers.
/// المعلم يسجل الدخول بالبريد وكلمة المرور → JWT → RLS تسمح بالوصول للبيانات المصرح بها فقط.
class AuthService extends GetxService {
  SupabaseClient get _client => Supabase.instance.client;

  final Rx<TeacherModel?> currentUser = Rx<TeacherModel?>(null);
  final RxBool isAuthenticated = false.obs;

  /// استدعاؤه من الشاشة الابتدائية لضمان انتهاء تحميل الجلسة قبل تحديد المسار.
  Future<void> ensureSessionLoaded() async {
    await _loadSession();
  }

  @override
  void onInit() {
    super.onInit();
    _loadSession();
    _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _fetchTeacherProfile();
      } else {
        currentUser.value = null;
        isAuthenticated.value = false;
      }
    });
  }

  /// استعادة الجلسة من Supabase وحمل بيانات المعلم إن وُجدت.
  Future<void> _loadSession() async {
    final session = _client.auth.currentSession;
    if (session != null) {
      await _fetchTeacherProfile();
    } else {
      currentUser.value = null;
      isAuthenticated.value = false;
    }
  }

  Future<TeacherModel?> _fetchTeacherProfile() async {
    try {
      // أولاً: جلب teacher_id من app_user عبر auth.uid()
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      // جلب app_entity_id من app_user
      final appUserRes = await _client
          .from('app_user')
          .select('app_entity_id, user_type')
          .eq('auth_user_id', userId)
          .maybeSingle();

      if (appUserRes == null || appUserRes['user_type'] != 'teacher') {
        return null;
      }

      final teacherId = appUserRes['app_entity_id'] as int;

      // جلب بيانات المعلم بـ id صريح
      final res = await _client
          .from('teachers')
          .select(
            'id, teacher_code, full_name, email, phone_number, profile_image_url, created_at',
          )
          .eq('id', teacherId)
          .maybeSingle();

      if (res == null) return null;

      final teacher = TeacherModel.fromTeacherRow(res);
      currentUser.value = teacher;
      isAuthenticated.value = true;
      return teacher;
    } catch (e) {
      currentUser.value = null;
      isAuthenticated.value = false;
      return null;
    }
  }

  /// تسجيل الدخول بالبريد وكلمة المرور (Supabase Auth يتحقق ويعطي JWT).
  Future<LoginResult> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final teacher = await _fetchTeacherProfile();
      if (teacher == null) {
        await _client.auth.signOut();
        return LoginResult(
          success: false,
          message: 'لم يتم العثور على بيانات المعلم. تواصل مع الإدارة.',
        );
      }
      return LoginResult(
        success: true,
        message: 'تم تسجيل الدخول بنجاح',
        user: teacher,
      );
    } on AuthException catch (e) {
      final msg = _authErrorMessage(e.message);
      return LoginResult(success: false, message: msg);
    } catch (e) {
      return LoginResult(
        success: false,
        message: 'حدث خطأ أثناء تسجيل الدخول. تحقق من الاتصال.',
      );
    }
  }

  String _authErrorMessage(String message) {
    if (message.contains('Invalid login credentials') ||
        message.contains('invalid_credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    }
    if (message.contains('Email not confirmed')) {
      return 'يرجى تأكيد البريد الإلكتروني أولاً';
    }
    return message;
  }

  /// تسجيل الخروج (إنهاء الجلسة المحفوظة في Supabase).
  Future<void> logout() async {
    await _client.auth.signOut();
    currentUser.value = null;
    isAuthenticated.value = false;
  }

  /// تحديث بيانات المعلم في جدول teachers (RLS تسمح للمعلم بتحديث بياناته فقط).
  Future<bool> updateUser(TeacherModel updatedUser) async {
    try {
      await _client
          .from('teachers')
          .update({
            'full_name': updatedUser.name,
            'email': updatedUser.email,
            'phone_number': updatedUser.phone,
            'profile_image_url': updatedUser.profileImage.isNotEmpty
                ? updatedUser.profileImage
                : null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', int.tryParse(updatedUser.id) ?? 0);
      currentUser.value = updatedUser;
      return true;
    } catch (_) {
      return false;
    }
  }
}

class LoginResult {
  final bool success;
  final String message;
  final TeacherModel? user;

  LoginResult({required this.success, required this.message, this.user});
}
