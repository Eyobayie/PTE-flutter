import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/teacher.dart';

Future<List<Teacher>> getTeachers() async {
  final response =
      await http.get(Uri.parse('http://localhost:5000/api/teachers'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Teacher> teachers =
        data.map((item) => Teacher.fromJson(item)).toList();
    return teachers;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> registerTeacher(
    String firstname, String lastname, String? email, int phone) async {
  final response =
      await http.post(Uri.parse('http://localhost:5000/api/teachers'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'firstname': firstname,
            'lastname': lastname,
            'email': email ?? '',
            'phone': phone
          }));
  if (response.statusCode != 200) {
    throw Exception('Failed to register the teacher');
  }
}

Future<void> deleteTeacher(int id) async {
  final response =
      await http.delete(Uri.parse('http://localhost:5000/api/teacher/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateTeacher(
    int id, String firstname, String lastname, String email, int phone) async {
  final response = await http.put(
      Uri.parse('http://localhost:5000/api/teacher/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'phone': phone
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to update data');
  }
}
