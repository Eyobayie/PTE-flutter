class Section {
  final int id;
  final String name;
  final String? description;
  final int gradeLevelId;

  Section(
      {required this.id,
      required this.name,
      this.description,
      required this.gradeLevelId});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      gradeLevelId: json['GradelevelId'],
    );
  }
}
