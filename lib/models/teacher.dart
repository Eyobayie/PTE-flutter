class Teacher {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String? email;
  final int phone;
  final String role;

  const Teacher({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    this.email,
    required this.phone,
    required this.role,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      username: json['username'],
      email:json['email'] as String,
      phone: json['phone'] as int,
      role: json['role'],
    );
  }
}
