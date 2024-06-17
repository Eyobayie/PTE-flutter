import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AnnouncemetProvider.dart';
import 'package:parent_teacher_engagement_app/screens/notification/UI/notification_list.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:provider/provider.dart';

class NotificationAppBarActions extends StatefulWidget {
  const NotificationAppBarActions({Key? key}) : super(key: key);

  @override
  State<NotificationAppBarActions> createState() =>
      _NotificationAppBarActionsState();
}

class _NotificationAppBarActionsState extends State<NotificationAppBarActions> {
  CustomPopupMenuController _controller = CustomPopupMenuController();
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
    return Row(
      children: <Widget>[
        CustomPopupMenu(
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: const Color(0xFFFFFFFF),
              constraints: BoxConstraints(maxHeight: 300), // Set max height
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      color: AppBarConstants.backgroundColor,
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(color: AppBarConstants.backgroundColor),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: context
                              .watch<AnnouncementProvider>()
                              .announcements
                              .map((announcement) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                print("onTap ${announcement.title}");
                                Navigator.of(context).pushNamed(
                                    NotificationList.notificationListRoute, arguments: announcement);
                                _controller.hideMenu();
                              },
                              child: Container(
                                height: 60,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: <Widget>[
                                    const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://via.placeholder.com/150'),
                                      radius: 15,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              announcement.title,
                                              style: const TextStyle(
                                                color: AppBarConstants
                                                    .backgroundColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // Text(
                                            //   'Date: ${announcement.date.toLocal().toString().split(' ')[0]}',
                                            //   style: const TextStyle(
                                            //     color: AppBarConstants
                                            //         .backgroundColor,
                                            //     fontSize: 12,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          pressType: PressType.singleClick,
          verticalMargin: -10,
          controller: _controller,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Stack(
              children: <Widget>[
                Icon(
                  Icons.notifications,
                  color: AppBarConstants.iconThem,
                ),
                Positioned(
                  left: 16.0,
                  child: Icon(
                    Icons.brightness_1,
                    color: Colors.red,
                    size: 9.0,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
