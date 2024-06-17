import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Teacher>> getTeachers() async {
  final response =
      // await http.get(Uri.parse('http://localhost:5000/api/teachers'));
      await http.get(Uri.parse(Api.teachersUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Teacher> teachers =
        data.map((item) => Teacher.fromJson(item)).toList();
    return teachers;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Teacher?> registerTeacher(
    String firstname, String lastname,String username, String? email, int phone, String role) async {
  final response = await http.post(Uri.parse(Api.teachersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'username':username,
        'email': email ?? '',
        'phone': phone,
        'role': role,
      }));
  if (response.statusCode == 200) {
    // Parse the response body to get the created department
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final createdTeacher = Teacher.fromJson(responseData);
    return createdTeacher;
  } else {
    throw Exception('Failed to create department');
  }
}

Future<void> deleteTeacher(int id) async {
  final response = await http.delete(Uri.parse('${Api.teacherUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateTeacher(
    int id, String firstname, String lastname, String username, String email, int phone, String role) async {
  final response = await http.put(Uri.parse('${Api.teacherUrl}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'username':username,
        'email': email,
        'phone': phone,
        'role': role,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to update data');
  }
}

Future<int> fetchTotalTeachers() async {
    try {
      final response = await http.get(Uri.parse(Api.teacherCount));

      if (response.statusCode == 200) {
        // If the server returns a successful response, parse the JSON
        final jsonData = json.decode(response.body);
        int totalTeachers = jsonData['totalTeachers'];
        return totalTeachers;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load total students');
      }
    } catch (error) {
      // Handle any exceptions thrown during the process
      print('FETCH TOTAL STUDENTS ERROR: $error');
      throw Exception('Failed to load total students');
    }
  }
