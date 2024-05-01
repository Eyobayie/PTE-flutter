import 'package:parent_teacher_engagement_app/models/section.dart';

class Gradelevel {
  final int id;
  final String grade;
  final String? description;
  final List<Section> sections;

  Gradelevel(
      {required this.id,
      required this.grade,
      required this.description,
      required this.sections});

  factory Gradelevel.fromJson(Map<String, dynamic> json) {
    List<dynamic> sectionList = json['Sections'] ?? [];
    List<Section> sections =
        sectionList.map((section) => Section.fromJson(section)).toList();
    return Gradelevel(
      id: json['id'],
      grade: json['grade'],
      description: json['description'],
      sections: sections,
    );
  }
}
