import 'package:flutter/material.dart';

class Announcement {
  final DateTime date;
  final String title;
  final String description;

  Announcement({
    required this.date,
    required this.title,
    required this.description,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
    };
  }
}
