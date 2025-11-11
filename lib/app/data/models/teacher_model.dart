// class TeacherModel {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String subject;
//   final String employeeId;
//   final String profileImage;
//   final int totalStudents;
//   final int totalClasses;
//   final double averageScore;
//   final DateTime joinedDate;

//   TeacherModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.subject,
//     required this.employeeId,
//     required this.profileImage,
//     required this.totalStudents,
//     required this.totalClasses,
//     required this.averageScore,
//     required this.joinedDate,
//   });

//   factory TeacherModel.fromJson(Map<String, dynamic> json) {
//     return TeacherModel(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       subject: json['subject'] ?? '',
//       employeeId: json['employeeId'] ?? '',
//       profileImage: json['profileImage'] ?? '',
//       totalStudents: json['totalStudents'] ?? 0,
//       totalClasses: json['totalClasses'] ?? 0,
//       averageScore: (json['averageScore'] ?? 0).toDouble(),
//       joinedDate: json['joinedDate'] != null
//           ? DateTime.parse(json['joinedDate'])
//           : DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'subject': subject,
//       'employeeId': employeeId,
//       'profileImage': profileImage,
//       'totalStudents': totalStudents,
//       'totalClasses': totalClasses,
//       'averageScore': averageScore,
//       'joinedDate': joinedDate.toIso8601String(),
//     };
//   }
// }

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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : [],
      employeeId: json['employeeId'] ?? '',
      school: json['school'],
      profileImage: json['profileImage'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
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
