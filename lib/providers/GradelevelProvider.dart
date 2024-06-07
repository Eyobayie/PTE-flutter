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
      Gradelevel? createdGradelevel =
          await createGradelevel(grade, description);
      if (createdGradelevel != null) {
        _gradelevels.add(createdGradelevel);
        notifyListeners();
      } else {
        print(
            'Error creating grade level at provider: created data is null or id is null');
      }
    } catch (e) {
      print('Error creating department from provider: $e');
    }
  }

  Future<void> updateGradelevelProvider(
      int id, String grade, String description) async {
    try {
      await updateGradelevel(id, grade, description);
      int index = _gradelevels.indexWhere((gradelevel) => gradelevel.id == id);
      if (index != -1) {
        _gradelevels[index] =
            Gradelevel(id: id, grade: grade, description: description);
        notifyListeners();
      } else {
        print('Error: Gradelevel not found in provider list');
      }
    } catch (e) {
      print('Error updating gradelevel: $e');
    }
  }
}
