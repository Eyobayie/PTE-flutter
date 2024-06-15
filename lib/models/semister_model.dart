import 'dart:convert';
import 'package:parent_teacher_engagement_app/models/academic_year.dart';

class Semister {
  final int? id;
  final String? name;
  final String? description;
  int AcademicYearId;

  Semister(
      { this.id,
       this.name,
      this.description,
      required this.AcademicYearId});

  // Factory method to create an instance of AcademicYear from JSON
  factory Semister.fromJson(Map<String, dynamic> json) {
    return Semister(
        id: json['id'] ?? 0,
        name: json['name'] as String?,
        description: json['description'] ?? '',
        AcademicYearId: json['AcademicYearId']);
  }

  // Method to convert an instance of AcademicYear to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'AcademicYearId': AcademicYearId
    };
  }
}
