 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/result_percentage.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';
 
 Future<List<ResultPercentage>> fetchAllResultPercentages() async {
    final response = await http.get(Uri.parse(Api.resultPercentagesUrl));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ResultPercentage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exams');
    }
  }

  Future<List<ResultPercentage>> fetchResultPercentagesPerYear(int academicYearId) async {
    final response = await http.get(Uri.parse('${Api.resultPercentagesUrl}/$academicYearId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ResultPercentage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exams');
    }
  }

  Future<ResultPercentage> createExam(String name, double percentage, int academicYearId, int semisterId) async {
    final response = await http.post(
      Uri.parse(Api.resultPercentagesUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
      'name': name,
      'percentage': percentage,
      'academicYearId': academicYearId,
      'semisterId':semisterId,
      })
    );

    if (response.statusCode == 200) {
      return ResultPercentage.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create exam');
    }
  }

  Future<void> updateResultPercentage(int id,String name, double percentage, int academicYearId, int semisterId) async {
    final response = await http.put(
      Uri.parse('${Api.resultPercentageUrl}/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
      'name': name,
      'percentage': percentage,
      'academicYearId': academicYearId,
      'semisterId':semisterId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update exam');
    }
  }

  Future<void> deleteResultPercentage(int? id) async {
    final response = await http.delete(
      Uri.parse('${Api.resultPercentageUrl}/$id'),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete exam');
    }
  }