class Semister {
  final int? id;
  final String? name;
  final String? description;
  final int? academicYearId;

  Semister({this.id, this.name, this.description, this.academicYearId});

  factory Semister.fromJson(Map<String, dynamic> json) {
    return Semister(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      academicYearId: json['AcademicYearId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'AcademicYearId': academicYearId,
    };
  }
}
class ResultPercentage {
  final int? id;
  final String? name;
  final double? percentage;
  final AcademicYear? academicYearId;
  final Semister? semisterId;

  ResultPercentage({
    this.id,
    this.name,
    this.percentage,
    this.academicYearId,
    this.semisterId,
  });

  factory ResultPercentage.fromJson(Map<String, dynamic> json) {
    return ResultPercentage(
      id: json['id'],
      name: json['name'],
      percentage: (json['percentage'] as num?)?.toDouble(),
      academicYearId: json['academicYearId'] != null ? AcademicYear.fromJson(json['academicYearId']) : null,
      semisterId: json['semisterId'] != null ? Semister.fromJson(json['semisterId']) : null,
    );
  }
}
class Student {
  final int? id;
  final String? firstname;
  final String? email;
  final int? phone;
  final int? sectionId;
  final int? parentId;
  final int? gradelevelId;
  final Parent? parent;

  Student({
    this.id,
    this.firstname,
    this.email,
    this.phone,
    this.sectionId,
    this.parentId,
    this.gradelevelId,
    this.parent,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstname: json['firstname'],
      email: json['email'],
      phone: json['phone'],
      sectionId: json['SectionId'],
      parentId: json['ParentId'],
      gradelevelId: json['GradelevelId'],
      parent: json['Parent'] != null ? Parent.fromJson(json['Parent']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'email': email,
      'phone': phone,
      'SectionId': sectionId,
      'ParentId': parentId,
      'GradelevelId': gradelevelId,
      'Parent': parent?.toJson(),
    };
  }
}

class StudentResult {
  final int? id;
  final int? result;
  final String? resultType;
  final AcademicYear? academicYear;
  final Semister? semister;
  final Subject? subject;
  final Student? student;
  final ResultPercentage? resultPercentage;

  StudentResult({
    this.id,
    this.result,
    this.resultType,
    this.academicYear,
    this.semister,
    this.subject,
    this.student,
    this.resultPercentage,
  });

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    print('Parsing StudentResult from JSON: $json');
    return StudentResult(
      id: json['id'],
      result: json['result'],
      resultType: json['ResultType'],
      academicYear: json['AcademicYear'] != null ? AcademicYear.fromJson(json['AcademicYear']) : null,
      semister: json['Semister'] != null ? Semister.fromJson(json['Semister']) : null,
      subject: json['Subject'] != null ? Subject.fromJson(json['Subject']) : null,
      student: json['Student'] != null ? Student.fromJson(json['Student']) : null,
      resultPercentage: json['ResultPercentage'] != null ? ResultPercentage.fromJson(json['ResultPercentage']) : null,
    );
  }
}
class AcademicYear {
  final int? id;
  final int? year;
  final String? description;

  AcademicYear({this.id, this.year, this.description});

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: json['id'],
      year: json['year'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'description': description,
    };
  }
}
class Parent {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  Parent({this.id, this.name, this.email, this.phone});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
class Subject {
  final int? id;
  final String? name;
  final String? description;
  final int? gradeLevelId;

  Subject({this.id, this.name, this.description, this.gradeLevelId});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      gradeLevelId: json['GradelevelId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'GradelevelId': gradeLevelId,
    };
  }

  @override
  String toString() {
    return 'Subject{id: $id, name: $name, description: $description, gradeLevelId: $gradeLevelId}';
  }
}
