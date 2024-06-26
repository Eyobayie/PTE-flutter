import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/screens/Auth/login.dart';
import 'package:parent_teacher_engagement_app/providers/studentResultProvider.dart';
import 'package:parent_teacher_engagement_app/screens/Assignment/assignment.dart';
import 'package:parent_teacher_engagement_app/screens/Assignment/assignment_screen.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_list_screen.dart';
import 'package:parent_teacher_engagement_app/screens/student/add_student_result.dart';
import 'package:parent_teacher_engagement_app/services/parent/parent.dart';
import 'package:parent_teacher_engagement_app/services/student/student.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';
import 'package:provider/provider.dart';
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
import 'package:parent_teacher_engagement_app/providers/resultPercentageProvider.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
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
import 'package:parent_teacher_engagement_app/screens/resultPercentage/add_result_percentage.dart';
import 'package:parent_teacher_engagement_app/screens/resultPercentage/result_percentage.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_registration.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_per_section.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_registration.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_detail.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_registration.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_screen.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_registration.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_screen.dart';
import 'package:parent_teacher_engagement_app/screens/academicYear/academicYear_registration.dart';
import 'package:parent_teacher_engagement_app/widgets/createAttendance.dart';
import 'package:parent_teacher_engagement_app/widgets/mainDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/AnnouncemetProvider.dart';

void main() {
  runApp(MyApp());
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
        ChangeNotifierProvider(create: (_) => ResultPercentageProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MaterialApp(
        title: 'Parent Teacher Engagement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
          useMaterial3: true,
          primaryColor: Colors.blue,
        ),
        routes: {
          '/': (context) => LoginDemo(),
          DepartmentPage.departmentRoute: (context) => const DepartmentPage(),
          NewDepartment.newDepartmentRoute: (context) => const NewDepartment(),
          SemisterListScreen.semisterRoute: (context) =>
              const SemisterListScreen(),
          NewSmister.newSemisterRoute: (context) => const NewSmister(),
          HelpDialog.helpDialogRoute: (context) => HelpDialog(),
          HelpResponsePage.helpRoute: (context) => const HelpResponsePage(),
          ResultPercentageScreen.resultPercentageRoute: (context) =>
              const ResultPercentageScreen(),
          NewResultPercentageForm.newResultParcentageRoute: (context) =>
              const NewResultPercentageForm(),
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
          StudentDetailScreen.studentDetailRoute: (context) =>
              const StudentDetailScreen(),
          AcademicYearRegistration.AcademicYearRegistrationRoute: (context) =>
              const AcademicYearRegistration(),
          NewAttendancePage.newAttendance: (context) =>
              const NewAttendancePage(),
          AssignTeacher.assignTeacherRoute: (context) => const AssignTeacher(),
          AssignmentScreen.assignmentRoute: (context) =>
              const AssignmentScreen(),
          AssignmentPage.assignmentRoute: (context) => const AssignmentPage(),
          CreateStudentResultForm.resultFormRote: (context) =>
              const CreateStudentResultForm(),
          NewTeacherAssignment.newTeacherAssignmentRoute: (context) =>
              const NewTeacherAssignment(),
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
  int _totalStudents = 0;
  int _totalParents = 0;
  int _totalTeachers = 0;
  bool _isLoading = false;
  int? id;
  String? role;

  @override
  void initState() {
    super.initState();
    _fetchTotalStudents();
    _fetchTotalParents();
    _fetchTotalTeachers();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      role = prefs.getString('role');
    });
  }

  Future<void> _fetchTotalStudents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int totalStudents = await fetchTotalStudents();
      setState(() {
        _totalStudents = totalStudents;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching total students: $error');
      setState(() {
        _isLoading = false;
        // Handle error scenario
      });
    }
  }

  Future<void> _fetchTotalTeachers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int totalTeachers = await fetchTotalTeachers();
      setState(() {
        _totalTeachers = totalTeachers;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching total teachers: $error');
      setState(() {
        _isLoading = false;
        // Handle error scenario
      });
    }
  }

  Future<void> _fetchTotalParents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int totalParents = await fetchTotalParentss();
      setState(() {
        _totalParents = totalParents;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching total parents: $error');
      setState(() {
        _isLoading = false;
        // Handle error scenario
      });
    }
  }

  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffAED1E4),
      appBar: AppBar(
        backgroundColor: AppBarConstants.backgroundColor,
        title: Text(
          widget.title,
          style: AppBarConstants.textStyle,
        ),
        actions: const <Widget>[
          NotificationAppBarActions(),
        ],
        iconTheme: const IconThemeData(color: AppBarConstants.iconThem),
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView(children: [
          Card(
            elevation: 2,
            child: Container(
              width: 400,
                height: 100,
              decoration: const BoxDecoration(
                color: Color(0XFF3856f0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.group,
                  size: 30,
                  color: Colors.white,
                ),
                title: const Text('Total students',
                    style: AppBarConstants.textStyle),
                subtitle:
                    Text('$_totalStudents', style: AppBarConstants.textStyle),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
           if (role == 'teacher' || role == 'admin') 
            Card(
              elevation: 2,
              child: Container(
                width: 400,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0XFFD64149),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.book,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Text('Assignments', style: AppBarConstants.textStyle),
                ),
              ),
            ),
          if (role == "admin")
            Card(
              elevation: 2,
              child: Container(
                width: 400,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0XFFE3A627),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.group,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: const Text('Total teachers',
                      style: AppBarConstants.textStyle),
                  subtitle:
                      Text('$_totalTeachers', style: AppBarConstants.textStyle),
                ),
              ),
            ),
          if (role == "admin")
            Card(
              elevation: 2,
              child: Container(
                width: 400,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0XFF53cf53),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.notification_important,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: Text('Announcemets', style: AppBarConstants.textStyle),
                ),
              ),
            ),
          if (role == "admin")
            Card(
              elevation: 2,
              child: Container(
                width: 400,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppBarConstants.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.group,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Total parents',
                    style: AppBarConstants.textStyle,
                  ),
                  subtitle:
                      Text('$_totalParents', style: AppBarConstants.textStyle),
                ),
              ),
            ),
        ]),
      ),
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
