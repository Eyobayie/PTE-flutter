import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
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
              color: Colors.blue,
            ),
            child: Text('User profile'),
          ),
          sideBar(context, 'Departments', const Icon(Icons.home),
              DepartmentPage.departmentRoute),
          sideBar(context, 'Teachers', const Icon(Icons.person),
              TeacherScree.teacherRoute),
          sideBar(context, 'Parents', const Icon(Icons.people),
              ParentScreen.parentRoute),
          sideBar(context, 'Grades', const Icon(Icons.star),
              GradelevelScreen.gradelevelScreenRoute),
          sideBar(context, 'Students', const Icon(Icons.book_online),
              SubjectScreen.subjectRoute),
          sideBar(
              context,
              'Teachers',
              const Icon(Icons.person_outline_outlined),
              TeacherScree.teacherRoute)
        ],
      ),
    );
  }
}
