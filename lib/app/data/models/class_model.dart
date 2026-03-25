class ClassModel {
  final String id;
  final String name;
  final String subject;
  final String grade;
  final int totalStudents;
  final int activeStudents;
  final double averageScore;
  final int totalQuizzes;
  final String color;
  final String icon;
  final int? subjectId;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.totalStudents,
    required this.activeStudents,
    required this.averageScore,
    required this.totalQuizzes,
    required this.color,
    required this.icon,
    this.subjectId,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: (json['id']?.toString() ?? json['section_id']?.toString() ?? ''),
      name: json['name'] ?? json['section_name'] ?? '',
      subject: json['subject'] ?? json['subject_name'] ?? '',
      grade: json['grade'] ?? json['grade_name'] ?? '',
      totalStudents: json['totalStudents'] ?? json['student_count'] ?? 0,
      activeStudents: json['activeStudents'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      totalQuizzes: json['totalQuizzes'] ?? 0,
      color: json['color'] ?? '0xFF6366F1',
      icon: json['icon'] ?? '📚',
    );
  }

  /// من صف نتيجة get_teacher_classes (أو v_teacher_classes).
  factory ClassModel.fromTeacherClassRow(Map<String, dynamic> row) {
    final sectionId = row['section_id'];
    final subjId = row['subject_id'];
    return ClassModel(
      id: '${sectionId}_$subjId',
      name: (row['section_name']?.toString() ?? ''),
      subject: (row['subject_name']?.toString() ?? ''),
      grade: (row['grade_name']?.toString() ?? ''),
      totalStudents: (row['student_count'] is int)
          ? row['student_count'] as int
          : int.tryParse(row['student_count']?.toString() ?? '0') ?? 0,
      activeStudents: 0,
      averageScore: 0.0,
      totalQuizzes: 0,
      color: '0xFF6366F1',
      icon: '📚',
      subjectId: subjId is int ? subjId : int.tryParse(subjId?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'grade': grade,
      'totalStudents': totalStudents,
      'activeStudents': activeStudents,
      'averageScore': averageScore,
      'totalQuizzes': totalQuizzes,
      'color': color,
      'icon': icon,
    };
  }
}
