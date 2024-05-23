import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Student>> getStudents() async {
  final response = await http.get(Uri.parse(ApiService.studentsUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Student> students =
        data.map((item) => Student.fromJson(item)).toList();
    return students;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Student>> getStudentPerSection(
    int gradelevelId, int sectionId) async {
  final response = await http.get(Uri.parse(
      '${ApiService.studentPerSectionUrl}/$gradelevelId/section/$sectionId'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Student> students =
        data.map((student) => Student.fromJson(student)).toList();
    print('STUDENT PERSECTION IS...${students}');
    return students;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Student?> registerStudent(String firstname, String? email, int? phone,
    int sectionId, int gradelevelId, int parentId) async {
  final response = await http.post(Uri.parse(ApiService.parentstUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'email': email ?? '',
        'phone': phone ?? 000,
        'SectionId': sectionId,
        'GradelevelId': gradelevelId,
        'ParentId': parentId,
      }));
  if (response.statusCode == 200) {
    // Parse the response body to get the created department
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final registeredStudent = Student.fromJson(responseData);
    return registeredStudent;
  } else {
    throw Exception('Failed to create student');
  }
}

Future<void> deleteStudent(int id) async {
  final response = await http.delete(Uri.parse('${ApiService.studentUrl}/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete student');
  }
}

Future<void> updateParent(int id, String firstname, String email, int phone,
    int sectionId, int parentId, int gradelevelId) async {
  final response = await http.put(Uri.parse('${ApiService.studentUrl}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'email': email,
        'phone': phone,
        'SectionId': sectionId,
        'ParentId': parentId,
        'GradelevelId': gradelevelId,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to update data');
  }
}
