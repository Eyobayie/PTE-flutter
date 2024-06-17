class Parent {
  final int id;
  String firstname;
  String lastname;
  String username;
  String? email;
  int phone;
  String? role;
  String? password;

  Parent({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    this.email,
    this.role,
    this.password,
    required this.phone,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'username': username,
    'email': email,
    'phone': phone,
    'role': role,
    'password': password,
  };

  @override
  String toString() {
    return 'Parent{id: $id, firstname: $firstname, lastname: $lastname, username: $username, email: $email, phone: $phone, role: $role, password: $password}';
  }
}
