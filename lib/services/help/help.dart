import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/help.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

// Fetch all helps
Future<List<Help>> getHelps() async {
  final response = await http.get(Uri.parse(Api.helpsUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Help.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load helps');
  }
}

// Fetch help by ID
Future<Help> fetchHelp(int id) async {
  final response = await http.get(Uri.parse('${Api.helpUrl}/$id'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Help.fromJson(data);
  } else {
    throw Exception('Failed to load help');
  }
}

// Create new help
// Future<void> createHelp(Help help) async {
//   final response = await http.post(
//     Uri.parse(ApiService.helpsUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(help.toJson()),
//   );
//   if (response.statusCode != 200) {
//     throw Exception('Failed to create help');
//   }
// }

Future<Help> createHelp(
    String description, DateTime date, int? ParentId) async {
  final response = await http.post(
    Uri.parse(Api.helpsUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'description': description,
      'date': date.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Help.fromJson(data);
  } else {
    throw Exception('Failed to create help');
  }
}

// Update help
Future<void> updateHelp(Help help) async {
  final response = await http.put(
    Uri.parse('${Api.helpUrl}/${help.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(help.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update help');
  }
}

// Delete help by ID
Future<void> deleteHelp(int id) async {
  final response = await http.delete(Uri.parse('${Api.helpUrl}/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete help');
  }
}

// Fetch helps with responses by parent ID
Future<List<Help>> fetchHelpsWithResponsesByParentId(int ParentId) async {
  final response =
      await http.get(Uri.parse('${Api.helpWithResponse}/$ParentId'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Help.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load helps with responses');
  }
}
