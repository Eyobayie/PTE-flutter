class Parent {
  final int id;
  String firstname;
  String lastname;
  String? email;
  int phone;

  Parent(
      {required this.id,
      required this.firstname,
      required this.lastname,
      this.email,
      required this.phone});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone,
      };
  String toString() {
    return 'Parent{id: $id, firstname: $firstname, lastname: $lastname, email: $email, phone: $phone}';
  }
}
