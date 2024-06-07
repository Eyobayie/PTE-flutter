import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/providers/AssignmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/AttendanceProvider.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/StudentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SectionProvider.dart';
import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/providers/TeacherProvider.dart';
import 'package:parent_teacher_engagement_app/providers/assinTeacher_provider.dart';
import 'package:parent_teacher_engagement_app/providers/helpProvider.dart';
import 'package:parent_teacher_engagement_app/providers/helpResponseProvider.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/screens/Assignment/assignment.dart';
import 'package:parent_teacher_engagement_app/screens/academicYear/academic_year.dart';
import 'package:parent_teacher_engagement_app/screens/assign_teacher/assign_teacher.dart';
import 'package:parent_teacher_engagement_app/screens/assign_teacher/newAssign_teacher.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradeDetail.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/new_grade.dart';
import 'package:parent_teacher_engagement_app/screens/help/help_Dialog.dart';
import 'package:parent_teacher_engagement_app/screens/helpResponse/helpResponse.dart';
import 'package:parent_teacher_engagement_app/screens/notification/UI/notification_action.dart';
import 'package:parent_teacher_engagement_app/screens/notification/UI/notification_list.dart';
import 'package:parent_teacher_engagement_app/screens/notification/announcement.dart';
import 'package:parent_teacher_engagement_app/screens/notification/announcement_form.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_registration.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_list_screen.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_registration.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_per_section.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_registration.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_detail.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_registration.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_screen.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_registration.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_screen.dart';
import 'package:parent_teacher_engagement_app/screens/academicYear/academicYear_registration.dart';
import 'package:parent_teacher_engagement_app/widgets/mainDrawer.dart';
import 'package:provider/provider.dart';

import 'providers/AnnouncemetProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => GradelevelProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => SectionProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => AcademicYearProvider()),
        ChangeNotifierProvider(create: (_) => HelpProvider()),
        ChangeNotifierProvider(create: (_) => HelpResponseProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => SemisterProvider()),
        ChangeNotifierProvider(create: (_) => AssignTeacherProvider()),
        ChangeNotifierProvider(create: (context) => StudentProvider()),
        // Add StudentProvider here
      ],
      child: MaterialApp(
        title: 'Parent Teacher Engagement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
          useMaterial3: true,
          primaryColor: Colors.blue,
        ),
        // Set up the routes here
        routes: {
          '/': (context) =>
              const MyHomePage(title: 'Parent Teacher Engagement'),
          DepartmentPage.departmentRoute: (context) => const DepartmentPage(),

          NewDepartment.newDepartmentRoute: (context) => const NewDepartment(),
          NewSmister.newSemisterRoute: (context) => const NewSmister(),
          HelpDialog.helpDialogRoute: (context) => HelpDialog(),
          HelpResponsePage.helpRoute: (context) => const HelpResponsePage(),
          //AssignmentPage.assignmentRoute: (context) => AssignmentPage(),

          GradelevelScreen.gradelevelScreenRoute: (context) =>
              const GradelevelScreen(),
          NotificationList.notificationListRoute: (context) =>
              const NotificationList(),
          GradeDetailScreen.gradeDetailScreenRoute: (context) =>
              const SizedBox(),
          AcademicYearScreen.academicYearRoute: (context) =>
              const AcademicYearScreen(),
          NewAnnouncement.announcementRoute: (context) =>
              const NewAnnouncement(),
          AnnouncementForm.AnnouncementFormRoute: (context) =>
              const AnnouncementForm(),
          NewGradeLevel.newgradelevelRoute: (context) => const NewGradeLevel(),
          TeacherScreen.teacherRoute: (context) => const TeacherScreen(),
          TeacherRegistration.teacherRegistrationRoute: (context) =>
              const TeacherRegistration(),
          ParentScreen.parentRoute: (context) => const ParentScreen(),
          ParentRegistration.ParentRegistrationRoute: (context) =>
              const ParentRegistration(),
          CreateSection.createSectionRoute: (context) => const CreateSection(),
          SubjectScreen.subjectRoute: (context) => const SubjectScreen(),
          SubjectRegistration.SubjectRegistrationRoute: (context) =>
              const SubjectRegistration(),
          StudentPerSection.studentRoute: (context) =>
              const StudentPerSection(),
          StudentRegistration.StudentRegistrationRoute: (context) =>
              const StudentRegistration(),
          AcademicYearRegistration.AcademicYearRegistrationRoute: (context) =>
              const AcademicYearRegistration(), // Add this route
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isHelpActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppBarConstants.backgroundColor,
        title: Text(
          widget.title,
          style: AppBarConstants.textStyle,
        ),
        actions: const <Widget>[
          NotificationAppBarActions(),
        ],
        iconTheme: IconThemeData(color: AppBarConstants.iconThem),
      ),
      drawer: const MainDrawer(),
      body: const Center(
        child: Text('There will be something here'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Text('Help?'),
      // ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isHelpActive = !_isHelpActive;
          });
          if (_isHelpActive) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return HelpDialog();
              },
            ).then((_) {
              setState(() {
                _isHelpActive = false;
              });
            });
          }
        },
        shape: const CircleBorder(),
        backgroundColor: AppBarConstants.backgroundColor,
        tooltip: "Help",
        child: Icon(
          _isHelpActive ? Icons.close : Icons.help_outline,
          color: AppBarConstants.iconThem,
        ),
      ),
    );
  }
}
