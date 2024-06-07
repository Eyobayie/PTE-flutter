import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/announcement.dart';
import 'package:parent_teacher_engagement_app/services/announcement/announcemet.dart';

class AnnouncementProvider extends ChangeNotifier {
  List<Announcement> _announcements = [];
  String _error = '';

  String get error => _error;

  List<Announcement> get announcements => _announcements;

  Future<void> fetchAnnouncements() async {
    try {
      _announcements = await getAnnouncements();
      notifyListeners();
    } catch (e) {
      print('Error fetching announcements: $e');
    }
    notifyListeners();
  }

  Future<void> deleteAnnouncementProvider(int id) async {
    try {
      await deleteAnnouncement(id);
      _announcements.removeWhere((announcement) => announcement.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting announcement: $e');
    }
  }

  // Create new announcement
  Future<void> createAnnouncementProvider(
      DateTime date, String title, String description) async {
    try {
      Announcement? createdAnnouncement =
          await registerAnnouncementt(title, description);
      if (createdAnnouncement != null) {
        _announcements.add(createdAnnouncement);
        notifyListeners();
      } else {
        print(
            'Error creating announcement: createdAnnouncement is null or id is null');
      }
    } catch (e) {
      print('Error creating announcement from provider: $e');
    }
  }

  // Update existing announcement
  Future<void> updateAnnouncementProvider(
      int id, String title, String description) async {
    try {
      await updateAnnouncement(id, title, description);
      int index =
          _announcements.indexWhere((announcement) => announcement.id == id);
      if (index != -1) {
        _announcements[index] =
            Announcement(id: id, title: title, description: description);
        notifyListeners();
      } else {
        print('Error: Announcement not found in provider list');
      }
    } catch (e) {
      print('Error updating announcement: $e');
    }
  }
}
