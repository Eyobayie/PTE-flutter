// ignore_for_file: non_constant_identifier_names

class AssignTeacherModel {
  final int id;
  final int TeacherId;
  final int AcademicYearId;
  final int SemisterId;
  final int DepartmentID;
  final int SubjectId;
  final int GradelevelId;
  final int SectionId;

  AssignTeacherModel(
      {required this.id,
      required this.TeacherId,
      required this.AcademicYearId,
      required this.SemisterId,
      required this.DepartmentID,
      required this.SubjectId,
      required this.GradelevelId,
      required this.SectionId});
  factory AssignTeacherModel.fromJson(Map<String, dynamic> json) {
    return AssignTeacherModel(
        id: json['id'],
        TeacherId: json['TeacherId'],
        AcademicYearId: json['AcademicYearId'],
        SemisterId: json['SemisterId'],
        DepartmentID: json['DepartmentID'],
        SubjectId: json['SubjectId'],
        GradelevelId: json['GradelevelId'],
        SectionId: json['SectionId']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'TeacherId': TeacherId,
      'AcademicYearId': AcademicYearId,
      'SemisterId': SemisterId,
      'DepartmentID': DepartmentID,
      'SubjectId': SubjectId,
      'GradelevelId': GradelevelId,
      'SectionId': SectionId
    };
  }

  String toString() {
    return 'assignTeacher{id: $id,TeacherId: $TeacherId, AcademicYearId: $AcademicYearId,  SemisterId: $SemisterId, DepartmentID: $DepartmentID, SubjectId: $SubjectId, GradelevelId:$GradelevelId, SectionId: $SectionId}';
  }
}
