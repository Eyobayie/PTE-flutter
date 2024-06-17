import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<dynamic> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(Api.login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      await _saveUserData(responseData);  // Save the user data in shared preferences
      if (responseData['role'] == 'parent') {
        return Parent.fromJson(responseData);
      } else if (responseData['role'] == 'teacher') {
        return Teacher.fromJson(responseData);
      } else if (responseData['role'] == 'admin') {
        return Teacher.fromJson(responseData);
      } 
      else {
        throw Exception('Unknown user role');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<void> _saveUserData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', data['id']);
    await prefs.setString('firstname', data['firstname']);
    await prefs.setString('lastname', data['lastname']);
    await prefs.setString('username', data['username']);
    await prefs.setString('email', data['email']);
    await prefs.setInt('phone', data['phone']);
    await prefs.setString('role', data['role']);
  }
}
