import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:accordion/accordion.dart';
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

  static const loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Detail',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
      ),
      backgroundColor: Color.fromRGBO(245, 238, 238, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Accordion(
                headerBackgroundColor: Colors.white,
                headerBorderColor: Color.fromARGB(255, 184, 193, 195),
                headerBorderColorOpened: Color.fromARGB(255, 181, 190, 190),
                headerBorderWidth: 1,
                contentBackgroundColor: Colors.white,
                contentBorderColor: Color.fromARGB(255, 184, 193, 195),
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
                    header: const Text('Notifier name', style: headerStyle),
                    content: const Text(loremIpsum, style: contentStyle),
                  ),
                ],
              ),
              //const SizedBox(height: 20),
              Card(
                color: const Color.fromRGBO(255, 255, 255, 1),
                //elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 184, 193, 195),
                  ),
                ),
                child: const Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'This is a description inside the card. You can add more content here to make the card informative and attractive.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
