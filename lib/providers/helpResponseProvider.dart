import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/help.dart';
import 'package:parent_teacher_engagement_app/services/help/help.dart';

class HelpResponseProvider extends ChangeNotifier {
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
}
