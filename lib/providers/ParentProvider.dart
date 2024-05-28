import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/services/parent/parent.dart';

class ParentProvider extends ChangeNotifier {
  List<Parent> _parents = [];

  List<Parent> get parents => _parents;
  String _error = '';

  String get error => _error;

  Future<void> fetchParents() async {
    try {
      _parents = await getParents();
      notifyListeners();
      print('_parents: $parents');
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

  void addParent(Parent parent) {
    _parents.add(parent);
    notifyListeners();
  }

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

  Future<void> updateParentProvider(int id, String firstname, String lastname,
      String email, int phone) async {
    try {
      await updateParent(id, firstname, lastname, email, phone);
      int index = _parents.indexWhere((parent) => parent.id == id);
      if (index != -1) {
        _parents[index] = Parent(
          id: id,
          firstname: firstname,
          lastname: lastname,
          email: email,
          phone: phone,
        );
        notifyListeners();
      } else {
        print('Error: Teacher not found in provider list');
      }
    } catch (e) {
      print('Error updating teacher: $e');
    }
  }
}
