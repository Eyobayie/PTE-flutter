import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';

class ParentProvider extends ChangeNotifier {
  List<Parent> _parents = [];

  List<Parent> get parents => _parents;

  // Method to fetch parents (example implementation)
  Future<void> fetchParents() async {
    // Fetch parents from API or database

    notifyListeners();
  }
}
