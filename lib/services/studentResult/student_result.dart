
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/student_result.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<StudentResult>> fetchStudentResults(int studentId) async {
  final url = Uri.parse('${Api.studentResultsUrl}/$studentId'); // Replace with your API endpoint
  final response = await http.get(url);

  // Print the raw response for debugging
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    // Parse the JSON only if the response status is 200 (OK)
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => StudentResult.fromJson(data)).toList();
  } else {
    // Throw an exception if the status code is not 200
    throw Exception('Failed to load student results: ${response.statusCode}');
  }
}

Future<StudentResult> createStudentResult({
    required int studentId,
    required double result,
    required String resultType,
    required int academicYearId,
    required int semisterId,
    required int subjectId,
    required int resultPercentageId,
  }) async {
    final response = await http.post(
      Uri.parse('${Api.studentResultsUrl}/$studentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'result': result,
        'ResultType': resultType,
        'AcademicYearId': academicYearId,
        'SemisterId': semisterId,
        'SubjectId': subjectId,
        'ResultPercentageId': resultPercentageId,
      }),
    );

    if (response.statusCode == 201) {
      return StudentResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create student result');
    }
  }
