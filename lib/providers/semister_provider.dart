import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/semister_model.dart';
import 'package:parent_teacher_engagement_app/services/semister/semister_service.dart';

class SemisterProvider with ChangeNotifier {
  List<Semister> _semisters = [];
  String _error = '';
  Semister? _selectedSemister;
  bool _isLoading = false;

  List<Semister> get semisters => _semisters;
  String get error => _error;

  Semister? get selectedSemister => _selectedSemister;
  bool get isLoading => _isLoading;

  Future<void> fetchSemisters() async {
    _isLoading = true;
    notifyListeners();
    try {
      _semisters = await getSemisters();
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSemisterById(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedSemister = await getSemisterById(id);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSemisterByAcademicYearId(int academicYearId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedSemister = await getSemisterByAcademicYearId(academicYearId);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSemisterByAcademicYearIdSemisterId(
      int academicYearId, int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedSemister =
          await getSemisterByAcademicYearIdSemisterId(academicYearId, id);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSemisterProvider(
      String name, String? description, int academicYearId) async {
    _isLoading = true;
    notifyListeners();
    try {
      Semister newSemister =
          await createSemister(name, description, academicYearId);
      _semisters.add(newSemister);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSemisterProvider(
      int id, String name, String description, int academicYearId) async {
    _isLoading = true;
    notifyListeners();
    try {
      Semister updatedSemister = Semister(
        id: id,
        name: name,
        description: description,
        AcademicYearId: academicYearId,
      );
      await updateSemister(updatedSemister);
      int index = _semisters.indexWhere((s) => s.id == id);
      if (index != -1) {
        _semisters[index] = updatedSemister;
        notifyListeners();
      }
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSemisterProvider(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await deleteSemister(id);
      _semisters.removeWhere((semister) => semister.id == id);
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
