class Subject {
  final int id;
  final String? name;
  final String? description;
  final int GradelevelId;

  Subject({
    required this.id,
    required this.name,
    this.description,
    required this.GradelevelId,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
       id: json['id'] ?? 0,
       name: json['name'] as String?,
        description: json['description'] ?? '',
        GradelevelId: json['GradelevelId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description ?? '',
      'gradelevel': GradelevelId,
    };
  }

  String toString() {
    return 'subject{id: $id,name: $name, description: $description, gradelevel: $GradelevelId}';
  }
}
