
class HelpResponse {
  final int id;
  final String description;
  final DateTime date;
  final int helpId;

  HelpResponse({
    required this.id,
    required this.description,
    required this.date,
    required this.helpId,
  });

  factory HelpResponse.fromJson(Map<String, dynamic> json) {
    return HelpResponse(
      id: json['id'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      helpId: json['HelpId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'HelpId': helpId,
    };
  }
}
