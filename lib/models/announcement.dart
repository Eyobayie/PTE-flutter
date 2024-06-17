class Announcement {
  final int id;
  final String title;
  final String description;
  final DateTime date;

  Announcement(
      {required this.id, required this.date, required this.title, required this.description});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
    };
  }
}
