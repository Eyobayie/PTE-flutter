import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Gradelevel>> getGradelevels() async {
  final response = await http.get(Uri.parse(ApiService.gradeLevelsUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Gradelevel> gradelevels =
        data.map((item) => Gradelevel.fromJson(item)).toList();
    return gradelevels;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> createGradelevel(String grade, String description) async {
  final response = await http.post(Uri.parse(ApiService.gradeLevelsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'grade': grade,
        'description': description,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to create data');
  }
}

Future<void> deleteGradelevel(int id) async {
  final response =
      await http.delete(Uri.parse('${ApiService.gradeLevelUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateGradelevel(int id, String name, String desctiption) async {
  final response = await http.put(Uri.parse('${ApiService.gradeLevelUrl}/$id'),
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

Future<Gradelevel> fetchGradeWithSections(int id) async {
  try {
    final response =
        await http.get(Uri.parse('${ApiService.gradeLevelUrl}/$id/sections'));

    if (response.statusCode == 200) {
      final data = Gradelevel.fromJson(jsonDecode(response.body)['grade']);
      return data;
    } else {
      throw Exception(
          'Failed to load grade. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load grade: $e');
  }
}
