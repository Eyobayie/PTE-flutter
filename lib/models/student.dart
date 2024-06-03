class Student {
  int id;
  String firstname;
  String? email;
  int? phone;
  int SectionId;
  int ParentId;
  int GradelevelId;

  Student({
    required this.id,
    required this.firstname,
    this.email,
    this.phone,
    required this.SectionId,
    required this.ParentId,
    required this.GradelevelId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstname: json['firstname'],
      email: json['email'],
      phone: json['phone'],
      SectionId: json['SectionId'],
      ParentId: json['ParentId'],
      GradelevelId: json['GradelevelId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'email': email,
        'phone': phone,
        'SectionId': SectionId,
        'ParentId': ParentId,
        'GradelevelId': GradelevelId,
      };
  String toString() {
    return 'student{id: $id,firstname: $firstname, email: $email, phone: $phone, SectionId: $SectionId, ParentId: $ParentId,GradelevelId: $GradelevelId}';
  }
}
