import 'help_response.dart';

class Help {
  final int id;
  final String description;
  final DateTime date;
  final int? parentId;
  final List<HelpResponse>? helpResponses;

  Help({
    required this.id,
    required this.description,
    required this.date,
    this.parentId,
    this.helpResponses = const [],
  });

  factory Help.fromJson(Map<String, dynamic> json) {
    return Help(
      id: json['id'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      parentId: json['ParentId'],
      helpResponses: (json['HelpResponses'])
          ?.map((item) => item == null ? null : HelpResponse.fromJson(item))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'ParentId': parentId,
      'HelpResponses': helpResponses?.map((item) => item.toJson()).toList(),
    };
  }

  String toString() {
    return 'help{id: $id, description: $description, date: $date, ParentId: $parentId, date: $date}';
  }
}
