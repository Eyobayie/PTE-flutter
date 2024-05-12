import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';

class TeacherProvider extends ChangeNotifier {
  List<Teacher> _teachers = [];

  List<Teacher> get teachers => _teachers;

  // Method to fetch teachers (example implementation)
  Future<void> fetchTeachers() async {
    // Fetch teachers from API or database

    notifyListeners();
  }
}
