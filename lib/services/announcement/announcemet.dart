import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parent_teacher_engagement_app/models/announcement.dart';
import 'package:parent_teacher_engagement_app/services/api.dart';

Future<List<Announcement>> getAnnouncements() async {
  final response = await http.get(Uri.parse(Api.AnnouncementUrl));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final List<Announcement> parents =
        data.map((item) => Announcement.fromJson(item)).toList();
    return parents;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Announcement?> registerAnnouncementt(
  DateTime date,
  String title,
  String description,
) async {
  final response = await http.post(Uri.parse(Api.AnnouncementUrl),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: jsonEncode(<String, dynamic>{
        'date': date,
        'title': title,
        'email': description
      }));
  if (response.statusCode == 200) {
    // Parse the response body to get the created department
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final registeredAnnouncement = Announcement.fromJson(responseData);
    return registeredAnnouncement;
  } else {
    throw Exception('Failed to create department');
  }
}

Future<void> deleteAnnouncement(int id) async {
  final response = await http.delete(Uri.parse('${Api.AnnouncementUrl}/$id'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete data');
  }
}

Future<void> updateAnnouncement(
  int id,
  String date,
  String title,
  String description,
) async {
  final response = await http.put(Uri.parse('${Api.AnnouncementUrl}/$id'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: jsonEncode(<String, dynamic>{
        'date': date,
        'title': title,
        'description': description,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to update data');
  }
}
