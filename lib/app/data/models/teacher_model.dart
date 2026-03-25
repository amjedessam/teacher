class TeacherModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> subjects; // ✅ تغيير من String إلى List<String>
  final String employeeId;
  final String? school; // ✅ إضافة حقل المدرسة
  final String profileImage;
  final int totalStudents;
  final int totalClasses;
  final double averageScore;
  final DateTime joinedDate;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subjects,
    required this.employeeId,
    this.school,
    required this.profileImage,
    required this.totalStudents,
    required this.totalClasses,
    required this.averageScore,
    required this.joinedDate,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: (json['id']?.toString() ?? ''),
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phone_number'] ?? '',
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : [],
      employeeId:
          (json['employeeId'] ?? json['teacher_code']?.toString() ?? ''),
      school: json['school'],
      profileImage: json['profileImage'] ?? json['profile_image_url'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      joinedDate: json['joinedDate'] != null || json['created_at'] != null
          ? DateTime.tryParse(
                  json['joinedDate']?.toString() ??
                      json['created_at']?.toString() ??
                      '',
                ) ??
                DateTime.now()
          : DateTime.now(),
    );
  }

  /// من صف جدول teachers في Supabase (بعد تسجيل الدخول عبر Auth + RLS).
  factory TeacherModel.fromTeacherRow(Map<String, dynamic> row) {
    return TeacherModel(
      id: (row['id']?.toString() ?? ''),
      name: (row['full_name']?.toString() ?? ''),
      email: (row['email']?.toString() ?? ''),
      phone: (row['phone_number']?.toString() ?? ''),
      subjects: [],
      employeeId: (row['teacher_code']?.toString() ?? ''),
      school: null,
      profileImage: (row['profile_image_url']?.toString() ?? ''),
      totalStudents: 0,
      totalClasses: 0,
      averageScore: 0.0,
      joinedDate: row['created_at'] != null
          ? (DateTime.tryParse(row['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'subjects': subjects,
      'employeeId': employeeId,
      'school': school,
      'profileImage': profileImage,
      'totalStudents': totalStudents,
      'totalClasses': totalClasses,
      'averageScore': averageScore,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  // ✅ Helper: الحصول على المادة الأساسية
  String get primarySubject => subjects.isNotEmpty ? subjects.first : '';

  // ✅ Helper: الحصول على جميع المواد كنص
  String get subjectsText => subjects.join(', ');

  // ✅ Helper: نسخة من الـ Model مع تعديلات
  TeacherModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    List<String>? subjects,
    String? employeeId,
    String? school,
    String? profileImage,
    int? totalStudents,
    int? totalClasses,
    double? averageScore,
    DateTime? joinedDate,
  }) {
    return TeacherModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subjects: subjects ?? this.subjects,
      employeeId: employeeId ?? this.employeeId,
      school: school ?? this.school,
      profileImage: profileImage ?? this.profileImage,
      totalStudents: totalStudents ?? this.totalStudents,
      totalClasses: totalClasses ?? this.totalClasses,
      averageScore: averageScore ?? this.averageScore,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
