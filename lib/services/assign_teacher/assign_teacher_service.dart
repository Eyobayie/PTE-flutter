// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/assign_teacher_model.dart';

import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<AssignTeacherModel>> getAssignedTeachers() async {
  final response = await http.get(Uri.parse(Api.teacherassignments));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<AssignTeacherModel> students =
        data.map((item) => AssignTeacherModel.fromJson(item)).toList();
    return students;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<AssignTeacherModel> getAssignedTeacherById(int id) async {
  final response = await http.get(Uri.parse('${Api.teacherAssignment}/$id'));
  if (response.statusCode == 200) {
    return AssignTeacherModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Data');
  }
}

Future<AssignTeacherModel?> registerAssignTeacher(
  int TeacherId,
  int AcademicYearId,
  int SemisterId,
  int DepartmentID,
  int SubjectId,
  int GradelevelId,
  int SectionId,
) async {
  final response = await http.post(Uri.parse(Api.teacherassignments),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'TeacherId': TeacherId,
        'AcademicYearId': AcademicYearId,
        'SemisterId': SemisterId,
        'DepartmentID': DepartmentID,
        'SubjectId': SubjectId,
        'GradelevelId': GradelevelId,
        'SectionId': SectionId,
      }));
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final registeredStudent = AssignTeacherModel.fromJson(responseData);
    return registeredStudent;
  } else {
    throw Exception('Failed to create assign teacher');
  }
}

Future<void> deleteAssignedTeacher(int id) async {
  final response = await http.delete(Uri.parse('${Api.teacherAssignment}/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete assigned teacher');
  }
}

Future<void> updateSemister(AssignTeacherModel assignTeacherModel) async {
  final response = await http.put(
    Uri.parse('${Api.teacherAssignment}/${assignTeacherModel.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(assignTeacherModel.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update assignment');
  }
}
