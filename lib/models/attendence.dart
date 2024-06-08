class Attendance {
  final int id;
  final DateTime date;
  final bool isPresent;
  final int StudentId;
  final int TeacherId;

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
      isPresent: json['isPresent'],
      StudentId: json['StudentId'],
      TeacherId: json['TeacherId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'StudentId': StudentId,
      'TeacherId': TeacherId,
    };
  }
}
