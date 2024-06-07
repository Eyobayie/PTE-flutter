import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/services/student/student.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];

  List<Student> get students => _students;

  // Method to fetch parents (example implementation)
  Future<void> fetchStudents() async {
    // Fetch parents from API or database
    try {
      _students = await getStudents();
      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
    notifyListeners();
  }

  Future<void> deleteStudentProvider(int id) async {
    try {
      await deleteStudent(id);
      _students.removeWhere((student) => student.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting parent: $e');
    }
  }

// create new gradelevel
  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  // create a parent provider
  Future<void> createStudentProvider(String firstname, String? email,
      int? phone, int sectionId, int gradelevelId, int parentId) async {
    try {
      Student? createdStudent = await registerStudent(
          firstname, email, phone, sectionId, gradelevelId, parentId);
      if (createdStudent != null) {
        _students.add(createdStudent);
        notifyListeners();
      } else {
        print(
            'Error creating student at provider: createdStudent is null or id is null');
      }
    } catch (e) {
      print('Error creating student from provider: $e');
    }
  }
}
