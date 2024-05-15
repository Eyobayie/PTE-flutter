import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/services/gradelevel/gradelevel.dart';

class GradelevelProvider extends ChangeNotifier {
  List<Gradelevel> _gradelevels = [];

  String _error = '';

  List<Gradelevel> get gradelevels => _gradelevels;

  String get error => _error;

  void setError(String error) {
    _error = error;
  }

  // Method to fetch gradelevels (example implementation)
  Future<void> fetchGradelevels() async {
    // Fetch gradelevels from API or database
    try {
      _gradelevels = await getGradelevels();
      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
  }

  // delete a gradelevel by id
  Future<void> deleteGradelevelProvider(int id) async {
    try {
      await deleteGradelevel(id);
      _gradelevels.removeWhere((gradelevel) => gradelevel.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting department: $e');
    }
  }

// create new gradelevel
  void addGradelevel(Gradelevel gradelevel) {
    _gradelevels.add(gradelevel);
    notifyListeners();
  }
// create a new gradelevel

  Future<void> createGradelevelProvider(
      String grade, String? description) async {
    try {
      Gradelevel? createdDepartment =
          await createGradelevel(grade, description);
      if (createdDepartment != null) {
        _gradelevels.add(createdDepartment);
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
