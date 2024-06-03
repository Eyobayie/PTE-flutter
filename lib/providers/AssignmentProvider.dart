import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/assignment.dart';
import 'package:parent_teacher_engagement_app/services/assignment/assignmentService.dart';

class AssignmentProvider with ChangeNotifier {
  List<Assignment> _assignments = [];
  Assignment? _assignment;
  bool _isLoading = false;
  String _error = '';

  List<Assignment> get assignments => _assignments;
  Assignment? get assignment => _assignment;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchAssignments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _assignments = await getAssignments();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAssignment(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _assignment = await getAssignment(id);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAssignment(String title, String description, int SubjectId,
      DateTime givenDate, DateTime endDate) async {
    _isLoading = true;

    try {
      final newAssignment = await createAssignment(
          title, description, SubjectId, givenDate, endDate);
      _assignments.add(newAssignment);
      _error = '';
    } catch (e) {
      _error = e.toString();
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAssignmentRecord(Assignment assignment) async {
    _isLoading = true;
    notifyListeners();

    try {
      await updateAssignment(assignment);
      _assignments = _assignments.map((a) {
        return a.id == assignment.id ? assignment : a;
      }).toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAssignmentRecord(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await deleteAssignment(id);
      _assignments.removeWhere((assignment) => assignment.id == id);
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
