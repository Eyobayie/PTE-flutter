class Teacher {
  final int id;
  final String firstname;
  final String lastname;
  final String? email;
  final int phone;

  const Teacher({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.email,
    required this.phone  
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      email:json['email'] as String,
      phone: json['phone'] as int
    );
  }
}
