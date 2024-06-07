import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/semister_model.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Semister>> getSemisters() async {
  final response = await http.get(Uri.parse(Api.semisters));
  if (response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((semister) => Semister.fromJson(semister)).toList();
  } else {
    throw Exception('Failed to load semisters');
  }
}

Future<Semister> getSemisterById(int id) async {
  final response = await http.get(Uri.parse('${Api.semister}/$id'));
  if (response.statusCode == 200) {
    return Semister.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load semister');
  }
}

Future<Semister> getSemisterByAcademicYearId(int academicYearId) async {
  final response =
      await http.get(Uri.parse('${Api.academicyearsemisters}/$academicYearId'));
  if (response.statusCode == 200) {
    return Semister.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load semister by Academic year id');
  }
}

Future<Semister> getSemisterByAcademicYearIdSemisterId(
    int academicYearId, int id) async {
  final response = await http.get(Uri.parse(
      '${Api.semisterAcademicyear}/$academicYearId/${Api.semister}/$id'));
  if (response.statusCode == 200) {
    return Semister.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to load semister by Academic year id and semister id');
  }
}

Future<Semister> createSemister(
    String name, String? description, int AcademicYearId) async {
  final response = await http.post(
    Uri.parse(Api.semisters),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'description': description ?? '',
      'AcademicYearId': AcademicYearId,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Semister.fromJson(responseData);
  } else {
    // Log the response body for more details on the error
    print('Failed to create semister: ${response.body}');
    throw Exception('Failed to create semister');
  }
}

Future<void> updateSemister(Semister semister) async {
  final response = await http.put(
    Uri.parse('${Api.semister}/${semister.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(semister.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update semister');
  }
}

Future<void> deleteSemister(int id) async {
  final response = await http.delete(Uri.parse('${Api.semister}/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete semister');
  }
}
