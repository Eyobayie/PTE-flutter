import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/attendence.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Attendance>> getAttendances(int studentId) async {
  final response =
      await http.get(Uri.parse('${ApiService.attendaceUrl}/$studentId'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Attendance.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load Attendance');
  }
}

Future<Attendance> getAttendance(int id, int studentId) async {
  final response =
      await http.get(Uri.parse('${ApiService.attendaceUrl}/$studentId/$id'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Attendance.fromJson(data);
  } else {
    throw Exception('Failed to load Attendance');
  }
}

Future<Attendance> createAttendance(
    int studentId, DateTime date, int TeacherId, bool isPresent) async {
  final response = await http.post(
    Uri.parse('${ApiService.attendaceUrl}/$studentId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'StudentId': studentId,
      'TeacherId': TeacherId,
      'date': date.toIso8601String(),
      'isPresent': isPresent
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Attendance.fromJson(data);
  } else {
    throw Exception('Failed to create help');
  }
}

// Update help
Future<void> updateAttendance(Attendance attendance) async {
  final response = await http.put(
    Uri.parse(
        '${ApiService.attendaceUrl}/${attendance.StudentId}/${attendance.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(attendance.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update Attendence');
  }
}

Future<void> deleteAttendance(int id, int StudentId) async {
  final response =
      await http.delete(Uri.parse('${ApiService.attendaceUrl}/$StudentId/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete help');
  }
}
