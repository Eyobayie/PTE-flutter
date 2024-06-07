// models/announcement.dart
class Announcement {
  final int id;
  final String title;
  final String description;

  Announcement(
      {required this.id, required this.title, required this.description});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
