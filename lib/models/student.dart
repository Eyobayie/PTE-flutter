import 'package:parent_teacher_engagement_app/models/parent.dart';

class Student {
  int id;
  String? firstname;
  String? email;
  int? phone;
  int SectionId;
  int ParentId;
  int GradelevelId;
  Parent? parent;

  Student({
    required this.id,
    this.firstname,
    this.email,
    this.phone,
    required this.SectionId,
    required this.ParentId,
    required this.GradelevelId,
    this.parent,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      firstname: json['firstname'] as String?,
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
    'Parent': parent?.toJson(),
  };

  @override
  String toString() {
    return 'Student{id: $id, firstname: $firstname, email: $email, phone: $phone, SectionId: $SectionId, ParentId: $ParentId, GradelevelId: $GradelevelId}';
  }
}
