import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/section.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Section>> getSections() async {
  final response = await http.get(Uri.parse(ApiService.sectionsUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Section> sections =
        data.map((item) => Section.fromJson(item)).toList();
    return sections;
  } else {
    throw Exception('Failed to load sections');
  }
}

Future<void> createSection(
    String name, String? description, int gradelevelId) async {
  final response = await http.post(
    Uri.parse(ApiService.sectionsUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'description': description,
      'GradelevelId': gradelevelId,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to create section');
  }
}

Future<void> deleteSection(int id) async {
  final response = await http.delete(Uri.parse('${ApiService.teacherUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete section');
  }
}

Future<void> updateSection(int id, String name, String? description) async {
  final response = await http.put(
    Uri.parse('${ApiService.teacherUrl}/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'description': description,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update section');
  }
}
