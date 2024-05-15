import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/department.dart';
import 'package:parent_teacher_engagement_app/services/department/department.dart';

class DepartmentProvider extends ChangeNotifier {
  List<Department> _departments = [];
  String _error = '';

  List<Department> get departments => _departments;

  String get error => _error;

  Future<void> fetchDepartments() async {
    try {
      _departments = await getDepartments();
      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  Future<void> deleteDepartmentProvider(int id) async {
    try {
      await deleteDepartment(id);
      _departments.removeWhere((department) => department.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting department: $e');
    }
  }

// add a new department
  void addDepartment(Department department) {
    _departments.add(department);
    notifyListeners();
  }

  Future<void> createDepartmentProvider(
      String name, String? description) async {
    try {
      Department? createdDepartment = await createDepartment(name, description);
      if (createdDepartment != null) {
        _departments.add(createdDepartment);
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
