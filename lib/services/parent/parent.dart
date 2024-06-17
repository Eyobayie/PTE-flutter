import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Parent>> getParents() async {
  final response = await http.get(Uri.parse(Api.parentstUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Parent> parents =
        data.map((item) => Parent.fromJson(item)).toList();
    return parents;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Parent?> registerParent(
    String firstname, String lastname, String username,String? email, int phone, String role) async {
  final response = await http.post(Uri.parse(Api.parentstUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'username':username,
        'email': email ?? '',
        'phone': phone,
        'role':role,
      }));
  if (response.statusCode == 200) {
    // Parse the response body to get the created department
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final registeredParent = Parent.fromJson(responseData);
    return registeredParent;
  } else {
    throw Exception('Failed to create parent');
  }
}

Future<void> deleteParent(int id) async {
  final response = await http.delete(Uri.parse('${Api.parentUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateParent(
    int id, String firstname, String lastname, String username,String email, int phone, String role) async {
  final response = await http.put(Uri.parse('${Api.parentUrl}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'username':username,
        'email': email,
        'phone': phone,
        'role':role,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to update data');
  }
}
