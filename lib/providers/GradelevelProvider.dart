import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';

class GradelevelProvider extends ChangeNotifier {
  List<Gradelevel> _gradelevels = [];

  List<Gradelevel> get gradelevels => _gradelevels;

  // Method to fetch gradelevels (example implementation)
  Future<void> fetchGradelevels() async {
    // Fetch gradelevels from API or database

    notifyListeners();
  }
}
