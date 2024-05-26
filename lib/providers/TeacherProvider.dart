import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';

class TeacherProvider extends ChangeNotifier {
  List<Teacher> _teachers = [];

  List<Teacher> get teachers => _teachers;

  // Method to fetch teachers
  Future<void> fetchTeachers() async {
    try {
      List<Teacher> teacherData = await getTeachers();
      _teachers = teacherData;
      notifyListeners();
    } catch (e) {
      print('Error fetching teachers: $e');
    }
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

  void addTeacher(Teacher teacher) {
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
            'Error creating teacher: registeredTeacher is null or id is null');
      }
    } catch (e) {
      print('Error creating teacher from provider: $e');
    }
  }

  Future<void> updateTeacherProvider(int id, String firstname, String lastname,
      String email, int phone) async {
    try {
      await updateTeacher(id, firstname, lastname, email, phone);
      int index = _teachers.indexWhere((teacher) => teacher.id == id);
      if (index != -1) {
        _teachers[index] = Teacher(
          id: id,
          firstname: firstname,
          lastname: lastname,
          email: email,
          phone: phone,
        );
        notifyListeners();
      } else {
        print('Error: Teacher not found in provider list');
      }
    } catch (e) {
      print('Error updating teacher: $e');
    }
  }
}
