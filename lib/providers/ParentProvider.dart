import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/services/parent/parent.dart';

class ParentProvider extends ChangeNotifier {
  List<Parent> _parents = [];

  List<Parent> get parents => _parents;

  // Method to fetch parents (example implementation)
  Future<void> fetchParents() async {
    // Fetch parents from API or database
    try {
      _parents = await getParents();
      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
    notifyListeners();
  }

  Future<void> deleteParentProvider(int id) async {
    try {
      await deleteParent(id);
      _parents.removeWhere((parent) => parent.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting parent: $e');
    }
  }

// create new gradelevel
  void addParent(Parent parent) {
    _parents.add(parent);
    notifyListeners();
  }

  // create a parent provider
  Future<void> createParentProvider(
      String firstname, String lastname, String email, int phone) async {
    try {
      Parent? createdParent =
          await registerParent(firstname, lastname, email, phone);
      if (createdParent != null) {
        _parents.add(createdParent);
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
