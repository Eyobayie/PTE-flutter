import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/assignment.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Assignment>> getAssignments() async {
  final response = await http.get(Uri.parse(Api.assignmentUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Assignment.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load assignments');
  }
}

Future<Assignment> getAssignment(int id) async {
  final response = await http.get(Uri.parse('${Api.assignment}/$id'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Assignment.fromJson(data);
  } else {
    throw Exception('Failed to load Assignment');
  }
}

Future<Assignment> createAssignment(String title, String description,
    int SubjectId, DateTime givenDate, DateTime endDate) async {
  final response = await http.post(
    Uri.parse(Api.assignmentUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'title': title,
      'description': description,
      'SubjectId': SubjectId,
      'givenDate': givenDate.toIso8601String(),
      'endDate': endDate.toIso8601String()
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final createdAssignment = Assignment.fromJson(data);
    return createdAssignment;
  } else {
    throw Exception('Failed to create Assignment');
  }
}

// Update help
Future<void> updateAssignment(Assignment assignment) async {
  final response = await http.put(
    Uri.parse('${Api.assignment}/${assignment.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(assignment.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update Assignment');
  }
}

Future<void> deleteAssignment(int id) async {
  final response = await http.delete(Uri.parse('${Api.assignment}/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete Assignment');
  }
}
