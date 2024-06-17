import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/result_percentage.dart';
import 'package:parent_teacher_engagement_app/services/resultPercentage/result_percentage.dart';

class ResultPercentageProvider extends ChangeNotifier {
  List<ResultPercentage> _resultPercentages = [];
  String _error = '';

  List<ResultPercentage> get resultPercentages => _resultPercentages;
  String get error => _error;

  Future<void> fetchResultPercentages() async {
    try {
      _resultPercentages = await fetchAllResultPercentages();
      notifyListeners();
    } catch (e) {
      print('Error fetching result percentages: $e');
    }
  }

  Future<void> fetchResultPercentagesPerYearProvider(int academicYearId) async {
    try {
      _resultPercentages = await fetchResultPercentagesPerYear(academicYearId);
      notifyListeners();
    } catch (e) {
      print('Error fetching result percentages per year: $e');
    }
  }

  Future<void> deleteResultPercentageProvider(int? id) async {
    try {
      await deleteResultPercentage(id);
      _resultPercentages.removeWhere((result) => result.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting result percentage: $e');
    }
  }

  Future<void> createResultPercentage(String name, double percentage, int academicYearId, int semisterId) async {
    try {
      ResultPercentage? createdResultPercentage = await createExam(name, percentage, academicYearId, semisterId);
      if (createdResultPercentage != null) {
        _resultPercentages.add(createdResultPercentage);
        notifyListeners();
      } else {
        print('Error creating result percentage: createdResultPercentage is null');
      }
    } catch (e) {
      print('Error creating result percentage: $e');
    }
  }

  Future<void> updateResultPercentage(int id, String name, double percentage, academicYearId, semisterId) async {
    try {
      await updateResultPercentage(id, name, percentage, academicYearId, semisterId);
      int index = _resultPercentages.indexWhere((result) => result.id == id);
      if (index != -1) {
        _resultPercentages[index] = ResultPercentage(
          id: id,
          name: name,
          percentage: percentage,
          academicYearId: academicYearId,
          semisterId: semisterId,
        );
        notifyListeners();
      } else {
        print('Error: Result percentage not found in provider list');
      }
    } catch (e) {
      print('Error updating result percentage: $e');
    }
  }
}
