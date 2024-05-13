class Department {
  //final int id;
  final int id; // Make id nullable
  final String name;
  final String? description;

  const Department({required this.id, required this.name, this.description});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int, // Assign id as int?
      name: json['name'] as String,
      description: json['description'],
    );
  }
}
