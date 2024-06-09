import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parent_teacher_engagement_app/models/attendence.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';
import 'package:parent_teacher_engagement_app/services/attendance/attendaceService.dart';

class AttendanceProvider with ChangeNotifier {
  List<Attendance> _attendances = [];
  Attendance? _attendance;
  bool _isLoading = false;
  String _error = '';

  List<Attendance> get attendances => _attendances;
  Attendance? get attendance => _attendance;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchAttendances(int studentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _attendances = await getAttendances(studentId);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAttendance(int id, int studentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _attendance = await getAttendance(id, studentId);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAttendance(
    int studentId,
    DateTime date,
    int TeacherId,
    bool isPresent,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newAttendance = await createAttendance(
        studentId,
        date,
        TeacherId,
        isPresent,
      );
      _attendances.add(newAttendance);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBulkAttendance(
      List<Map<String, dynamic>> attendanceList) async {
    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('${Api.attendaceUrl}/bulk'); // Adjust endpoint as necessary
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(attendanceList),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Attendance data submitted successfully.');
      } else {
        // Handle error
        print('Failed to submit attendance data: ${response.body}');
        throw Exception('Failed to submit attendance data');
      }
    } catch (error) {
      print('Error submitting attendance data: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAttendanceRecord(Attendance attendance) async {
    _isLoading = true;
    notifyListeners();

    try {
      await updateAttendance(attendance);
      _attendances = _attendances.map((a) {
        return a.id == attendance.id ? attendance : a;
      }).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAttendanceRecord(int id, int StudentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await deleteAttendance(id, StudentId);
      _attendances.removeWhere((attendance) => attendance.id == id);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
