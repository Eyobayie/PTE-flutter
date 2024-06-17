
class Semister {
  final int id;
  final String name;
  final String? description;
  int AcademicYearId;

  Semister(
      {required this.id,
       required this.name,
      this.description,
      required this.AcademicYearId});

  // Factory method to create an instance of AcademicYear from JSON
  factory Semister.fromJson(Map<String, dynamic> json) {
    return Semister(
        id: json['id'],
        name: json['name'] ,
        description: json['description'] ?? '',
        AcademicYearId: json['AcademicYearId']);
  }

  // Method to convert an instance of AcademicYear to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'AcademicYearId': AcademicYearId
    };
  }
}
