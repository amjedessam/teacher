class StudentModel {
  final String id;
  final String name;
  final String email;
  final String studentCode;
  final String classId;
  final String className;
  final String profileImage;
  final double averageScore;
  final int totalQuizzes;
  final int completedQuizzes;
  final String
  masteryLevel; // Mastered, Proficient, Developing, Needs Improvement
  final List<SubjectPerformance> subjectPerformance;
  final DateTime lastActive;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.studentCode,
    required this.classId,
    required this.className,
    required this.profileImage,
    required this.averageScore,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.masteryLevel,
    required this.subjectPerformance,
    required this.lastActive,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      studentCode: json['studentCode'] ?? '',
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      profileImage: json['profileImage'] ?? '',
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      totalQuizzes: json['totalQuizzes'] ?? 0,
      completedQuizzes: json['completedQuizzes'] ?? 0,
      masteryLevel: json['masteryLevel'] ?? 'Developing',
      subjectPerformance:
          (json['subjectPerformance'] as List?)
              ?.map((e) => SubjectPerformance.fromJson(e))
              .toList() ??
          [],
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentCode': studentCode,
      'classId': classId,
      'className': className,
      'profileImage': profileImage,
      'averageScore': averageScore,
      'totalQuizzes': totalQuizzes,
      'completedQuizzes': completedQuizzes,
      'masteryLevel': masteryLevel,
      'subjectPerformance': subjectPerformance.map((e) => e.toJson()).toList(),
      'lastActive': lastActive.toIso8601String(),
    };
  }

  /// من صف جدول students في Supabase (مع اسم الصف إن وُجد).
  factory StudentModel.fromStudentRow(
    Map<String, dynamic> row, {
    String? className,
  }) {
    final sectionId = row['section_id']?.toString();
    return StudentModel(
      id: (row['id']?.toString() ?? ''),
      name: (row['full_name']?.toString() ?? ''),
      email: (row['email']?.toString() ?? ''),
      studentCode: (row['student_code']?.toString() ?? ''),
      classId: sectionId ?? '',
      className: className ?? '',
      profileImage: (row['profile_image_url']?.toString() ?? ''),
      averageScore: 0.0,
      totalQuizzes: 0,
      completedQuizzes: 0,
      masteryLevel: 'Developing',
      subjectPerformance: [],
      lastActive: row['last_login_at'] != null
          ? (DateTime.tryParse(row['last_login_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}

class SubjectPerformance {
  final String subjectName;
  final double score;
  final String trend; // up, down, stable

  SubjectPerformance({
    required this.subjectName,
    required this.score,
    required this.trend,
  });

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subjectName: json['subjectName'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      trend: json['trend'] ?? 'stable',
    );
  }

  Map<String, dynamic> toJson() {
    return {'subjectName': subjectName, 'score': score, 'trend': trend};
  }
}
