import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/screens/academicYear/academic_year.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/helpResponse/helpResponse.dart';
import 'package:parent_teacher_engagement_app/screens/notification/announcement.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_registration.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_screen.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  Widget sideBar(BuildContext context, String title, Icon icon, String route) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppBarConstants.backgroundColor,
            ),
            child: Text(
              'User profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          sideBar(context, 'Departments', const Icon(Icons.home),
              DepartmentPage.departmentRoute),
          sideBar(context, 'Teachers', const Icon(Icons.person),
              TeacherScreen.teacherRoute),
          sideBar(context, 'Parents', const Icon(Icons.people),
              ParentScreen.parentRoute),
          sideBar(context, 'Grades', const Icon(Icons.star),
              GradelevelScreen.gradelevelScreenRoute),
          sideBar(context, 'Subject', const Icon(Icons.book_online),
              SubjectScreen.subjectRoute),
          sideBar(context, 'Students', const Icon(Icons.people),
              StudentRegistration.StudentRegistrationRoute),
          sideBar(context, 'Announcements', const Icon(Icons.people),
              NewAnnouncement.announcementRoute),
          sideBar(
              context,
              'Academic years',
              const Icon(Icons.person_outline_outlined),
              AcademicYearScreen.academicYearRoute),
          sideBar(
              context, 'Help', Icon(Icons.help), HelpResponsePage.helpRoute),
        ],
      ),
    );
  }
}
