// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/assign_teacher_model.dart';
import 'package:parent_teacher_engagement_app/services/assign_teacher/assign_teacher_service.dart';

class AssignTeacherProvider with ChangeNotifier {
  List<AssignTeacherModel> _assignedTeachers = [];
  bool _isLoading = false;
  String _error = '';
  AssignTeacherModel? _singleAssignedTeacher;

  List<AssignTeacherModel> get assignedTeachers => _assignedTeachers;
  bool get isLoading => _isLoading;
  String get error => _error;
  AssignTeacherModel? get singleAssignedTeacher => _singleAssignedTeacher;

  Future<void> fetchAssignedTeachers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _assignedTeachers = await getAssignedTeachers();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = error.toString();
      notifyListeners();
    }
  }

  Future<void> fetchAssignedTeacherById(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _singleAssignedTeacher = await getAssignedTeacherById(id);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAssignedTeacher(
    int TeacherId,
    int AcademicYearId,
    int SemisterId,
    int DepartmentID,
    int SubjectId,
    int GradelevelId,
    int SectionId,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newAssignment = await registerAssignTeacher(
        TeacherId,
        AcademicYearId,
        SemisterId,
        DepartmentID,
        SubjectId,
        GradelevelId,
        SectionId,
      );
      if (newAssignment != null) {
        _assignedTeachers.add(newAssignment);
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      _error = error.toString();
      notifyListeners();
    }
  }

  Future<void> updateAssignedTeacher(
      AssignTeacherModel assignTeacherModel) async {
    _isLoading = true;
    notifyListeners();
    try {
      await updateSemister(assignTeacherModel);
      final index = _assignedTeachers
          .indexWhere((item) => item.id == assignTeacherModel.id);
      if (index != -1) {
        _assignedTeachers[index] = assignTeacherModel;
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      _error = error.toString();
      notifyListeners();
    }
  }

  Future<void> removeAssignedTeacher(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await deleteAssignedTeacher(id);
      _assignedTeachers.removeWhere((item) => item.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = error.toString();
      notifyListeners();
    }
  }

  // Add this method to filter by academic year
  List<AssignTeacherModel> filterByAcademicYear(int academicYearId) {
    return _assignedTeachers
        .where((teacher) => teacher.AcademicYearId == academicYearId)
        .toList();
  }
}
