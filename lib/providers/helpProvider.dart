import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/help.dart';
import 'package:parent_teacher_engagement_app/services/help/help.dart';

class HelpProvider extends ChangeNotifier {
  List<Help> _helps = [];
  String _error = '';

  List<Help> get helps => _helps;
  String get error => _error;

  Future<void> fetchHelps() async {
    try {
      _helps = await getHelps();
      print(' _helps: $_helps');
      notifyListeners();
    } catch (e) {
      print('Error fetching helps: $e');
    }
  }

  Future<void> createHelpProvider(
      String description, DateTime date, int? parentId) async {
    try {
      Help createdHelp = await createHelp(description, date, parentId);
      _helps.add(createdHelp);
      notifyListeners();
    } catch (e) {
      print('Error creating help from provider: $e');
    }
  }
}
