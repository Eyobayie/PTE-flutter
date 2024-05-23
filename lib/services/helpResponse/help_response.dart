import 'dart:convert';
import 'package:http/http.dart' as http;

class HelpResponseService {
  static const String baseUrl = 'http://your-backend-url/api';

  static Future<List<dynamic>> fetchHelpResponses() async {
    final response = await http.get(Uri.parse('$baseUrl/responses'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load help responses');
    }
  }

  static Future<List<dynamic>> fetchHelpResponseById(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/response/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load help response');
    }
  }

  static Future<void> createHelpResponse(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/responses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create help response');
    }
  }

  static Future<void> updateHelpResponse(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/response/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update help response');
    }
  }

  static Future<void> deleteHelpResponse(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/response/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete help response');
    }
  }
}
