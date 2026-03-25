import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/teacher_model.dart';

class StorageService extends GetxService {
  // ✅ تم التعديل: إزالة late final والتهيئة مباشرة
  final GetStorage _storage = GetStorage();

  // مفاتيح التخزين
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _sessionTokenKey = 'session_token';

  Future<bool> saveUser(TeacherModel user, String password) async {
    try {
      final users = getAllUsers();

      // التحقق من عدم تكرار البريد الإلكتروني
      if (users.any((u) => u['email'] == user.email)) {
        return false; // البريد الإلكتروني موجود مسبقاً
      }

      final userData = {
        ...user.toJson(),
        'password': _hashPassword(password), // تشفير كلمة المرور
        'created_at': DateTime.now().toIso8601String(),
      };

      users.add(userData);
      await _storage.write(_usersKey, users);
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  /// استرجاع جميع المستخدمين المسجلين
  List<Map<String, dynamic>> getAllUsers() {
    try {
      final usersData = _storage.read<List>(_usersKey);
      if (usersData == null) return [];
      return List<Map<String, dynamic>>.from(usersData);
    } catch (e) {
      print('Error reading users: $e');
      return [];
    }
  }

  /// التحقق من صحة بيانات تسجيل الدخول
  TeacherModel? validateCredentials(String email, String password) {
    try {
      final users = getAllUsers();
      final hashedPassword = _hashPassword(password);

      final user = users.firstWhereOrNull(
        (u) => u['email'] == email && u['password'] == hashedPassword,
      );

      if (user == null) return null;

      // إزالة كلمة المرور قبل إرجاع البيانات
      final userData = Map<String, dynamic>.from(user);
      userData.remove('password');

      return TeacherModel.fromJson(userData);
    } catch (e) {
      print('Error validating credentials: $e');
      return null;
    }
  }

  // ==================== إدارة الجلسة ====================

  /// حفظ معلومات المستخدم الحالي
  Future<void> saveCurrentUser(TeacherModel user) async {
    try {
      await _storage.write(_currentUserKey, user.toJson());
      await _storage.write(_isLoggedInKey, true);
      await _storage.write(_sessionTokenKey, _generateSessionToken(user.id));
    } catch (e) {
      print('Error saving current user: $e');
    }
  }

  /// استرجاع المستخدم الحالي
  TeacherModel? getCurrentUser() {
    try {
      final userData = _storage.read<Map<String, dynamic>>(_currentUserKey);
      if (userData == null) return null;
      return TeacherModel.fromJson(userData);
    } catch (e) {
      print('Error reading current user: $e');
      return null;
    }
  }

  /// التحقق من حالة تسجيل الدخول
  bool get isLoggedIn {
    try {
      return _storage.read<bool>(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// الحصول على رمز الجلسة
  String? get sessionToken {
    return _storage.read<String>(_sessionTokenKey);
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await _storage.remove(_currentUserKey);
      await _storage.write(_isLoggedInKey, false);
      await _storage.remove(_sessionTokenKey);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  /// مسح جميع البيانات
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // ==================== Helpers ====================
  /// تشفير بسيط لكلمة المرور (يجب استخدام bcrypt في الإنتاج)
  String _hashPassword(String password) {
    // في الإنتاج، استخدم crypto package أو bcrypt
    return password.split('').reversed.join() + '_hashed';
  }

  /// توليد رمز جلسة
  String _generateSessionToken(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${userId}_${timestamp}_token';
  }

  // ==================== تحديث بيانات المستخدم ====================

  /// تحديث معلومات المستخدم الحالي
  Future<bool> updateCurrentUser(TeacherModel updatedUser) async {
    try {
      // تحديث في قائمة المستخدمين
      final users = getAllUsers();
      final index = users.indexWhere((u) => u['id'] == updatedUser.id);

      if (index != -1) {
        final password = users[index]['password'];
        users[index] = {
          ...updatedUser.toJson(),
          'password': password, // الاحتفاظ بكلمة المرور
        };
        await _storage.write(_usersKey, users);
      }

      // تحديث المستخدم الحالي
      await saveCurrentUser(updatedUser);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }
}
