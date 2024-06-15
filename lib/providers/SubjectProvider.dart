import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/subject.dart';
import 'package:parent_teacher_engagement_app/services/subject/subject.dart';

class SubjectProvider extends ChangeNotifier {
  List<Subject> _subjects = [];
  List<Subject> _subjectGradeLevels = [];
  String _error = '';

  List<Subject> get subjects => _subjects;
  List<Subject> get subjectGradleles => _subjectGradeLevels;
  String get error => _error;

  Future<void> fetchSubjects() async {
    try {
      _subjects = await getSubjects();
      notifyListeners();
    } catch (e) {
      print('Error fetching subjects: $e');
    }
  }

  Future<void> deleteSubjectProvider(int id) async {
    try {
      await deleteSubject(id);
      _subjects.removeWhere((subject) => subject.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting subject: $e');
    }
  }

  void addDepartment(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  Future<void> createSubjectProvider(
      String name, String? description, int gradelevelId) async {
    try {
      Subject? createdSubject =
          await createSubject(name, description, gradelevelId);
      if (createdSubject != null) {
        _subjects.add(createdSubject);
        notifyListeners();
      } else {
        print('Error creating subject: created subject is null');
      }
    } catch (e) {
      print('Error creating subject: $e');
    }
  }

  Future<void> fetchSubjectByGradelevel(int gradeId) async {
    try {
      _subjectGradeLevels = await getSubjectsByGradelevel(gradeId);
      print('Fetched subjects by grade level: $_subjectGradeLevels');
      notifyListeners();
    } catch (e) {
      print('Error fetching subjects by grade level: $e');
    }
  }
}
