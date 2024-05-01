import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/parent.dart';

Future<List<Parent>> getParents() async {
  final response =
      await http.get(Uri.parse('http://localhost:5000/api/parents'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Parent> parents =
        data.map((item) => Parent.fromJson(item)).toList();
    return parents;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> registerParent(
    String firstname, String lastname, String? email, int phone) async {
  final response =
      await http.post(Uri.parse('http://localhost:5000/api/parents'),
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

Future<void> deleteParent(int id) async {
  final response =
      await http.delete(Uri.parse('http://localhost:5000/api/parent/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateParent(
    int id, String firstname, String lastname, String email, int phone) async {
  final response = await http.put(
      Uri.parse('http://localhost:5000/api/parent/$id'),
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
