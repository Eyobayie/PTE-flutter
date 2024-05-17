import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/announcement.dart';
import 'package:parent_teacher_engagement_app/services/announcement/announcemet.dart';

class AnnouncementProvider extends ChangeNotifier {
  List<Announcement> _announcements = [];

  List<Announcement> get announcements => _announcements;

  Future<void> fetchAnnouncements() async {
    try {
      _announcements = await getAnnouncements();
      notifyListeners();
    } catch (e) {
      print('Error fetching departments: $e');
    }
    notifyListeners();
  }

  // Future<void> deleteAnnouncementProvider(int id) async {
  //   try {
  //     await deleteAnnouncement(id);
  //     _announcements.removeWhere((announcement) => announcement.id == id);
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error deleting parent: $e');
  //   }
  // }

// create new gradelevel
  void addParent(Announcement announcement) {
    _announcements.add(announcement);
    notifyListeners();
  }

  Future<void> createAnnouncementProvider(
      DateTime date, String title, String description) async {
    try {
      Announcement? createdAnnouncement =
          await registerAnnouncementt(date, title, description);
      if (createdAnnouncement != null) {
        announcements.add(createdAnnouncement);
        notifyListeners();
      } else {
        print(
            'Error creating department at provider: createdDepartment is null or id is null');
      }
    } catch (e) {
      print('Error creating department from provider: $e');
    }
  }
}
