import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/screens/academicYear/academic_year.dart';
import 'package:parent_teacher_engagement_app/screens/assign_teacher/assign_teacher.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/helpResponse/helpResponse.dart';
import 'package:parent_teacher_engagement_app/screens/notification/announcement.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
import 'package:parent_teacher_engagement_app/screens/resultPercentage/result_percentage.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_list_screen.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_screen.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_screen.dart';
import 'package:parent_teacher_engagement_app/services/Auth/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  int? phone;
  String? role;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      firstname = prefs.getString('firstname');
      lastname = prefs.getString('lastname');
      username = prefs.getString('username');
      email = prefs.getString('email');
      phone = prefs.getInt('phone');
      role = prefs.getString('role');
    });
  }

  Widget sideBar(BuildContext context, String title, Icon icon, String route) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }
  List<Widget> adminRoles=[];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
           DrawerHeader(
            decoration: const BoxDecoration(
              color: AppBarConstants.backgroundColor,
            ),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${firstname ?? ''} ${lastname ?? ''}',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        phone != null ? 'Phone: $phone' : 'Phone: N/A',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
          ),
           if (role == 'teacher' || role == 'admin') 
            sideBar(context, 'Departments', const Icon(Icons.home), DepartmentPage.departmentRoute),
          sideBar(context, 'Teachers', const Icon(Icons.person), TeacherScreen.teacherRoute),
          if (role == 'teacher' || role == 'admin') 
          sideBar(context, 'Parents', const Icon(Icons.people), ParentScreen.parentRoute),
          sideBar(context, 'Grades', const Icon(Icons.star), GradelevelScreen.gradelevelScreenRoute),
          sideBar(context, 'Subject', const Icon(Icons.book_online), SubjectScreen.subjectRoute),
          if(role=='admin')
          sideBar(context, 'Announcements', const Icon(Icons.people), NewAnnouncement.announcementRoute),
           if(role=='admin')
          sideBar(context, 'Academic years', const Icon(Icons.person_outline_outlined), AcademicYearScreen.academicYearRoute),
          if(role=='admin')
          sideBar(context, 'Assign Teacher', const Icon(Icons.assistant), AssignTeacher.assignTeacherRoute),
          if(role=='admin')
          sideBar(context, 'Manage Semister', const Icon(Icons.assistant), SemisterListScreen.semisterRoute),
          if(role=='admin')
          sideBar(context, 'Result percentage', const Icon(Icons.percent), ResultPercentageScreen.resultPercentageRoute),
          if(role=='admin')    
          sideBar(context, 'Help', const Icon(Icons.help), HelpResponsePage.helpRoute),
           ListTile(title: const Text('Logout'),
           leading: const Icon(Icons.logout),
           onTap: (){
            clearAllData();
            Navigator.of(context).pushNamed('/');
           },
           )
        ],
      ),
    );
  }
}
