import 'package:parent_teacher_engagement_app/models/parent.dart';

class Student {
  int id;
  String firstname;
  String? email;
  int? phone;
  int SectionId;
  int ParentId;
  int GradelevelId;
  Parent? parent; // Add this line to include the Parent object

  Student({
    required this.id,
    required this.firstname,
    this.email,
    this.phone,
    required this.SectionId,
    required this.ParentId,
    required this.GradelevelId,
    this.parent,
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
      parent: json['Parent'] != null ? Parent.fromJson(json['Parent']) : null,
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
        'Parent': parent
            ?.toJson(), // Add this line to include the Parent object in JSON
      };
  String toString() {
    return 'student{id: $id,firstname: $firstname, email: $email, phone: $phone, SectionId: $SectionId, ParentId: $ParentId,GradelevelId: $GradelevelId}';
  }
}
