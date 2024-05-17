import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/subject.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Subject>> getSubjects() async {
  final response = await http.get(Uri.parse(ApiService.subjectsUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Subject> subjects =
        data.map((item) => Subject.fromJson(item)).toList();
    return subjects;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Subject?> createSubject(
    String name, String? description, int gradelevelId) async {
  final response = await http.post(
    Uri.parse(ApiService.subjectsUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'description': description ?? '',
      'GradelevelId': gradelevelId,
    }),
  );

  if (response.statusCode == 200) {
    // Parse the response body to get the created department
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final createdSubject = Subject.fromJson(responseData);
    return createdSubject;
  } else {
    throw Exception('Failed to create Subject');
  }
}

Future<void> deleteSubject(int id) async {
  final response = await http.delete(Uri.parse('${ApiService.subjectUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete subject');
  }
}

Future<void> updateSubject(
    int id, String name, String desctiption, int gradelevelId) async {
  final response = await http.put(Uri.parse('${ApiService.subjectUrl}$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'desctiption': desctiption,
        'GradelevelId': gradelevelId,
      }));

  if (response.statusCode != 200) {
    throw Exception('Failed to update subject');
  }
}
