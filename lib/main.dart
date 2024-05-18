import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AnnouncemetProvider.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SectionProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/providers/TeacherProvider.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradeDetail.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/new_grade.dart';
import 'package:parent_teacher_engagement_app/screens/notification/UI/notification_action.dart';
import 'package:parent_teacher_engagement_app/screens/notification/UI/notification_list.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_registration.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_registration.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_screen.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_registration.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_screen.dart';
import 'package:parent_teacher_engagement_app/widgets/mainDrawer.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DepartmentProvider()),
        ChangeNotifierProvider(create: (context) => GradelevelProvider()),
        ChangeNotifierProvider(create: (context) => TeacherProvider()),
        ChangeNotifierProvider(create: (context) => SectionProvider()),
        ChangeNotifierProvider(create: (context) => ParentProvider()),
        ChangeNotifierProvider(create: (context) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
      ],
      child: MaterialApp(
        title: 'Parent Teacher Engagement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
          useMaterial3: true,
          primaryColor: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/': (context) =>
              const MyHomePage(title: 'Parent Teacher Engagement'),
          DepartmentPage.departmentRoute: (context) => const DepartmentPage(),
          NewDepartment.newDepartmentRoute: (context) => const NewDepartment(),
          GradelevelScreen.gradelevelScreenRoute: (context) =>
              const GradelevelScreen(),
          NotificationList.notificationListRoute: (context) =>
              const NotificationList(),
          GradeDetailScreen.gradeDetailScreenRoute: (context) =>
              const SizedBox(),
          NewGradeLevel.newgradelevelRoute: (context) => const NewGradeLevel(),
          TeacherScree.teacherRoute: (context) => const TeacherScree(),
          TeacherRegistration.teacherRegistrationRoute: (context) =>
              const TeacherRegistration(),
          ParentScreen.parentRoute: (context) => const ParentScreen(),
          ParentRegistration.parentRegistrationRoute: (context) =>
              const ParentRegistration(),
          CreateSection.createSectionRoute: (context) => const CreateSection(),
          SubjectScreen.subjectRoute: (context) => const SubjectScreen(),
          SubjectRegistration.SubjectRegistrationRoute: (context) =>
              const SubjectRegistration(),
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
      ),
      drawer: const MainDrawer(),
      body: const Center(
        child: Text('There will be something here'),
      ),
    );
  }
}
