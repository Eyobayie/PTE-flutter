import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_screen.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

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
          ListTile(
            title: const Text('Departments'),
            onTap: () {
              Navigator.of(context).pushNamed(DepartmentPage.departmentRoute);
            },
          ),
          ListTile(
            title: const Text('Teachers'),
            onTap: () {
              Navigator.of(context).pushNamed(TeacherScree.teacherRoute);
            },
          ),
          ListTile(
            title: const Text('Parents'),
            onTap: () {
              Navigator.of(context).pushNamed(ParentScreen.parentRoute);
            },
          ),
          ListTile(
            title: const Text('Grades'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(GradelevelScreen.gradelevelScreenRoute);
            },
          ),
          ListTile(
            title: const Text('Subjects'),
            onTap: () {
              Navigator.of(context).pushNamed(SubjectScreen.subjectRoute);
            },
          ),
        ],
      ),
    );
  }
}
