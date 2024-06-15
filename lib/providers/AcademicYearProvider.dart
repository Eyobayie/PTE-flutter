import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/academic_year.dart';
import 'package:parent_teacher_engagement_app/services/academicYear/academic_year.dart';

class AcademicYearProvider extends ChangeNotifier {
  List<AcademicYear> _academicYears = [];
  String _error = '';

  List<AcademicYear> get academicYears => _academicYears;

  String get error => _error;

  Future<void> fetchAcademicYears() async {
    try {
      _academicYears = await getAcademicYears();
      notifyListeners();
    } catch (e) {
      print('Error fetching Academic years: $e');
    }
  }

  Future<void> deleteAcademicYearProvider(int? id) async {
    try {
      await deleteAcademicYear(id);
      _academicYears.removeWhere((academicYear) => academicYear.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting academic year: $e');
    }
  }

// add a new department
  void addDepartment(AcademicYear academicYear) {
    _academicYears.add(academicYear);
    notifyListeners();
  }

  Future<void> createAcademicYearProvider(int year, String? description) async {
    try {
      AcademicYear? createdAcademicYear =
          await createAcademicYear(year, description);
      if (createdAcademicYear != null) {
        _academicYears.add(createdAcademicYear);
        notifyListeners();
      } else {
        print(
            'Error creating department at provider: createdDepartment is null or id is null');
      }
    } catch (e) {
      print('Error creating academic year from provider: $e');
    }
  }
}
