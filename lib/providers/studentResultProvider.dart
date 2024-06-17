// providers/result_provider.dart
import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/student_result.dart';
import 'package:parent_teacher_engagement_app/services/studentResult/student_result.dart';

class ResultProvider extends ChangeNotifier {
  List<StudentResult> _results = [];
  String _error = '';

  List<StudentResult> get results => _results;
  String get error => _error;

  Future<void> fetchStudentResultsById(int studentId) async {
    try {
      _results = await fetchStudentResults(studentId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createStudentResultProvider({
    required int studentId,
    required double result,
    required String resultType,
    required int academicYearId,
    required int semisterId,
    required int subjectId,
    required int resultPercentageId,
  }) async {
    try {
      final newResult = await createStudentResult(
        studentId: studentId,
        result: result,
        resultType: resultType,
        academicYearId: academicYearId,
        semisterId: semisterId,
        subjectId: subjectId,
        resultPercentageId: resultPercentageId,
      );
      _results.add(newResult);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
