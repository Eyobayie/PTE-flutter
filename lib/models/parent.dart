import 'dart:convert';

class Parent {
  final int id;
  String firstname;
  String lastname;
  String username;
  String? email;
  int phone;
  String? role;

  Parent(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.username,
      this.email,
      this.role,
      required this.phone});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role:json['role']
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
      };
  String toString() {
    return 'Parent{id: $id, firstname: $firstname, lastname: $lastname,username:$username, email: $email, phone: $phone, role:$role}';
  }
}
