import 'package:flutter/material.dart';

class AcademicYear {
  final int year;
  final String? description;

  AcademicYear({
    required this.year,
    this.description,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      year: json['year'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'description': description,
    };
  }
}
