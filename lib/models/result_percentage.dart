class ResultPercentage {
  final int id;
  final String name;
  final double percentage;
  final int academicYearId;
  final int semisterId;

  ResultPercentage({
    required this.id,
    required this.name,
    required this.percentage,
    required this.academicYearId,
    required this.semisterId,
  });

  factory ResultPercentage.fromJson(Map<String, dynamic> json) {
    return ResultPercentage(
      id: json['id'],
      name: json['name'],
      percentage: json['percentage'],
      academicYearId: json['academicYearId'],
      semisterId: json['semisterId'], // Corrected typo from semisterId to semesterId
    );
  }
}
