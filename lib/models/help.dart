import 'help_response.dart';

class Help {
  final int id;
  final String description;
  final DateTime date;
  final int? ParentId;
  final List<HelpResponse>? helpResponses;

  Help({
    required this.id,
    required this.description,
    required this.date,
    this.ParentId,
    this.helpResponses = const [],
  });

  factory Help.fromJson(Map<String, dynamic> json) {
    return Help(
      id: json['id'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      ParentId: json['ParentId'],
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
      'ParentId': ParentId,
      'HelpResponses': helpResponses?.map((item) => item.toJson()).toList(),
    };
  }

  String toString() {
    return 'help{id: $id, description: $description, date: $date, ParentId: $ParentId, date: $date}';
  }
}
