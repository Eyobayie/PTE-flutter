import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/section.dart';

class SectionProvider extends ChangeNotifier {
  List<Section> _sections = [];

  List<Section> get sections => _sections;

  // Method to fetch sections (example implementation)
  Future<void> fetchSections() async {
    // Fetch sections from API or database

    notifyListeners();
  }
}
