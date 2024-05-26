import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/department.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Department>> getDepartments() async {
  final response = await http.get(Uri.parse(ApiService.departmentsUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Department> departments =
        data.map((item) => Department.fromJson(item)).toList();
    return departments;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Department?> createDepartment(String name, String? description) async {
  final response = await http.post(
    Uri.parse(ApiService.departmentsUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'description': description,
    }),
  );

  if (response.statusCode == 200) {
    // Parse the response body to get the created department
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final createdDepartment = Department.fromJson(responseData);
    return createdDepartment;
  } else {
    throw Exception('Failed to create department');
  }
}

Future<void> deleteDepartment(int id) async {
  final response =
      await http.delete(Uri.parse('${ApiService.departmentUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateDepartment(int id, String name, String desctiption) async {
  final response = await http.put(Uri.parse('${ApiService.departmentUrl}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'desctiption': desctiption,
      }));

  if (response.statusCode != 200) {
    throw Exception('Failed to update data');
  }
}
