class Attendance {
  final int id;
  final DateTime date;
  final int StudentId;
  final int TeacherId;
  final bool isPresent;

  Attendance({
    required this.id,
    required this.date,
    required this.isPresent,
    required this.StudentId,
    required this.TeacherId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
        id: json['id'],
        date: DateTime.parse(json['date']),
        StudentId: json['StudentId'],
        TeacherId: json['TeacherId'],
        isPresent: json['isPresent']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'StudentId': StudentId,
      'TeacherId': TeacherId,
      'isPresent': isPresent
    };
  }
}
