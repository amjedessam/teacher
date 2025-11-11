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
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      activeStudents: json['activeStudents'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      totalQuizzes: json['totalQuizzes'] ?? 0,
      color: json['color'] ?? '0xFF6366F1',
      icon: json['icon'] ?? '📚',
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
