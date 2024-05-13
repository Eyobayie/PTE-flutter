import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/screens/department/departments_page.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradeDetail.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradelevel_screen.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/new_grade.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_registration.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_screen.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
          useMaterial3: true,
          primaryColor: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/': (context) => const MyHomePage(title: 'PTE'),
          DepartmentPage.departmentRoute: (context) => const DepartmentPage(),
          NewDepartment.newDepartmentRoute: (context) => const NewDepartment(),
          GradelevelScreen.gradelevelScreenRoute: (context) =>
              const GradelevelScreen(),
          GradeDetailScreen.gradeDetailScreenRoute: (context) =>
              const GradeDetailScreen(),
          NewGradeLevel.newgradelevelRoute: (context) => const NewGradeLevel(),
          TeacherScree.teacherRoute: (context) => const TeacherScree(),
          TeacherRegistration.teacherRegistrationRoute: (context) =>
              const TeacherRegistration(),
          ParentScreen.parentRoute: (context) => const ParentScreen(),
          ParentRegistration.parentRegistrationRoute: (context) =>
              const ParentRegistration(),
          CreateSection.createSectionRoute: (context) => const CreateSection(),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const MainDrawer(),
      body: const Center(
        child: Text('There will be something here'),
      ),
    );
  }
}
