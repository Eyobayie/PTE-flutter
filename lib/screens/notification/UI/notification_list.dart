import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:accordion/accordion.dart';
import 'package:parent_teacher_engagement_app/models/announcement.dart';
import 'package:parent_teacher_engagement_app/providers/AnnouncemetProvider.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});
  static const String notificationListRoute = 'notificationListRoute';

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  static const headerStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  static const contentStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await context.read<AnnouncementProvider>().fetchAnnouncements();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcement=ModalRoute.of(context)!.settings.arguments as Announcement;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Detail',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
      ),
      backgroundColor: const Color.fromRGBO(245, 238, 238, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Accordion(
                headerBackgroundColor: Colors.white,
                headerBorderColor:const Color.fromARGB(255, 184, 193, 195),
                headerBorderColorOpened: const Color.fromARGB(255, 181, 190, 190),
                headerBorderWidth: 1,
                contentBackgroundColor: Colors.white,
                contentBorderColor: const Color.fromARGB(255, 184, 193, 195),
                contentBorderWidth: 1,
                contentHorizontalPadding: 20,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: [
                  AccordionSection(
                    isOpen: true,
                    contentVerticalPadding: 30,
                    rightIcon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(255, 184, 193, 195),
                      size: 16,
                    ),
                    header:  Text(announcement.title, style: headerStyle),
                    content:  Text(announcement.description, style: contentStyle),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
