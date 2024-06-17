class AcademicYear {
  final int id;
  final int year;
  final String? description;

  AcademicYear({ required this.id, required this.year, this.description});

  // Factory method to create an instance of AcademicYear from JSON
  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
       id: json['id'],
      year: json['year'],
      description: json['description'],
    );
  }

  // Method to convert an instance of AcademicYear to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'description': description,
    };
  }
}
