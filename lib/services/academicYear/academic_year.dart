import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/academic_year.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<AcademicYear>> getAcademicYears() async {
  final response = await http.get(Uri.parse(Api.academicYearsUrl));
  if (response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((academicYear) => AcademicYear.fromJson(academicYear))
        .toList();
  } else {
    throw Exception('Failed to load academic years');
  }
}

Future<AcademicYear> fetchAcademicYearById(int id) async {
  final response = await http.get(Uri.parse('${Api.academicYear}/$id'));
  if (response.statusCode == 200) {
    return AcademicYear.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load academic year');
  }
}

Future<AcademicYear?> createAcademicYear(int year, String? description) async {
  final response = await http.post(
    Uri.parse(Api.academicYearsUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'year': year,
      'description': description ?? '',
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return AcademicYear.fromJson(responseData);
  } else {
    // Log the response body for more details on the error
    print('Failed to create academic year: ${response.body}');
    throw Exception('Failed to create academic year');
  }
}

Future<void> updateAcademicYear(AcademicYear academicYear) async {
  final response = await http.put(
    Uri.parse('${Api.academicYear}/${academicYear.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(academicYear.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update academic year');
  }
}

Future<void> deleteAcademicYear(int? id) async {
  final response = await http.delete(Uri.parse('${Api.academicYear}/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete academic year');
  }
}
