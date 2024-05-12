// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/department.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';
import 'package:parent_teacher_engagement_app/services/department/department.dart';

class DepartmentProvider extends ChangeNotifier {
  List<Department> _departments = [];
  String _error = '';

  List<Department> get departments => _departments;

  String get error => _error;
  Future<void> fetchDepartments() async {
    try {
      List<Department> departmentData = await getDepartments();

      _departments = departmentData;

      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  // Future<void> deleteDepartmentProvider(int id) async {
  //   try {
  //     await deleteDepartment(id);

  //     _departments.removeWhere((department) => department.id == id);

  //     notifyListeners();
  //   } catch (e) {
  //     print('Error deleting department: $e');
  //   }
  // }
  Future<void> deleteDepartmentProvider(int? id) async {
    try {
      if (id == null) {
        throw ArgumentError.notNull('id');
      }

      await deleteDepartment(id);

      _departments.removeWhere((department) => department.id == id);

      notifyListeners();
    } catch (e) {
      print('Error deleting department: $e');
    }
  }

  void addDepartment(Department department) {
    _departments.add(department);
    notifyListeners();
  }

  // Future<void> createDepartmentProvider(String name, String description) async {
  //   try {
  //     Department createdDepartment = await createDepartment(name, description);
  //     _departments.add(createdDepartment);
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error creating department: $e');
  //   }
  // }
  Future<void> createDepartmentProvider(String name, String description) async {
    try {
      // Ensure that name and description are not null, provide default values if needed
      name ??= ''; // Set default value for name if null
      description ??= ''; // Set default value for description if null

      Department? createdDepartment = await createDepartment(name, description);
      if (createdDepartment != null && createdDepartment.id != null) {
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
