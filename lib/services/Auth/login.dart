import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

class LoginService {
  Future<dynamic> login(String username, int phone) async {
    final response = await http.post(
      Uri.parse(Api.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['role'] == 'parent') {
        return Parent.fromJson(responseData);
      } else if (responseData['role'] == 'teacher') {
        return Teacher.fromJson(responseData);
      } else {
        throw Exception('Unknown user role');
      }
    } else {
      throw Exception('Failed to login');
    }
  }
}
