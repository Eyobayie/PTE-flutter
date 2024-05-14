import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';

class TeacherProvider extends ChangeNotifier {
  List<Teacher> _teachers = [];

  List<Teacher> get teachers => _teachers;

  // Method to fetch teachers (example implementation)
  Future<void> fetchTeachers() async {
    // Fetch teachers from API or database
    try {
      List<Teacher> teacherData = await getTeachers();
      _teachers = teacherData;
      notifyListeners();
    } catch (e) {
      print('Error fetching teachers: $e');
    }
    notifyListeners();
  }

  Future<void> deleteTeacherProvider(int id) async {
    try {
      await deleteTeacher(id);
      _teachers.removeWhere((teacher) => teacher.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting teacher: $e');
    }
  }

  void addDepartment(Teacher teacher) {
    _teachers.add(teacher);
    notifyListeners();
  }

  Future<void> createTeacherProvider(
      String firstname, String lastname, String email, int phone) async {
    try {
      Teacher? registeredTeacher =
          await registerTeacher(firstname, lastname, email, phone);
      if (registeredTeacher != null) {
        _teachers.add(registeredTeacher);
        notifyListeners();
      } else {
        print(
            'Error creating department at provider: createdDepartment is null or id is null');
      }
    } catch (e) {
      print('Error creating department from provider: $e');
    }
  }
}
