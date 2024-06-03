class Assignment {
  final int id;
  final int SubjectId;
  final String title;
  final String description;
  final DateTime givenDate;
  final DateTime endDate;
  bool? isDone;
  Assignment(
      {required this.id,
      required this.SubjectId,
      required this.title,
      required this.description,
      required this.givenDate,
      required this.endDate,
      this.isDone});
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
        id: json['id'],
        SubjectId: json['SubjectId'],
        title: json['title'],
        description: json['description'],
        givenDate: DateTime.parse(json['givenDate']),
        endDate: DateTime.parse(json['endDate']),
        isDone: json['isDone']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SubjectId': SubjectId,
      'title': title,
      'description': description,
      'givenDate': givenDate,
      'endDate': endDate,
      'isDone': isDone
    };
  }

  String toString() {
    return 'assignment{id: $id,title: $title, description: $description,  SubjectId: $SubjectId, givenDate: $givenDate, endDate: $endDate}';
  }
}
