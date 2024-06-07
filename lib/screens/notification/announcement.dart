import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AnnouncemetProvider.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/screens/notification/announcement_form.dart';
import 'package:provider/provider.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';

import '../../constants/appbar_constants.dart';

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({Key? key});

  static const String announcementRoute = 'announcement';

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  bool _isLoading = false; // Local loading state in ExamHome

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading =
            true; // Set local isLoading to true before making the API call
      });
      // Use the provider to fetch data
      await context.read<AnnouncementProvider>().fetchAnnouncements();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var announceProvider = Provider.of<AnnouncementProvider>(context);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All Announcements',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AnnouncementForm.AnnouncementFormRoute);
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : announceProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${announceProvider.error}'),
                  )
                : Consumer<AnnouncementProvider>(
                    builder: (context, announcementProvider, child) {
                    if (announcementProvider.announcements.isEmpty) {
                      // If departments list is empty, fetch data
                      announcementProvider.fetchAnnouncements();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: announceProvider.announcements.length,
                        itemBuilder: (context, index) {
                          final announcement =
                              announceProvider.announcements[index];
                          return Dismissible(
                            key: Key(announcement.id.toString()),
                            child: Card(
                              elevation: CardConstants.elevationHeight,
                              margin: CardConstants.marginSize,
                              color: CardConstants.backgroundColor,
                              shape: CardConstants.rectangular,
                              child: ListTile(
                                leading: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.amber[400],
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        AnnouncementForm.AnnouncementFormRoute,
                                        arguments: announcement,
                                      );
                                    }),
                                title: Text(announcement.title),
                                subtitle: Text(announcement.description ?? ''),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    announceProvider.deleteAnnouncementProvider(
                                        announcement.id);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }));
  }
}
