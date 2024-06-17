import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/screens/student/add_student_result.dart';
import 'package:parent_teacher_engagement_app/widgets/attendance.dart';
import 'package:parent_teacher_engagement_app/widgets/performance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key});
  static const studentDetailRoute = 'studentDetail';

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? id;
  String? role;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
    Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      role = prefs.getString('role');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        title: Text(
          student.firstname ?? '',
          style: AppBarConstants.textStyle,
        ),
        actions: [
          if(role=="admin")
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    CreateStudentResultForm.resultFormRote,
                    arguments: student.id);
              },
              child: const Text(
                'Add result',
                style: TextStyle(color: Colors.white),
              ))
        ],
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Attendances'),
            Tab(text: 'Performance'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: TabBarView(
          controller: _tabController,
          children: [
            AttendanceWidget(studentId: student.id),
            ResultTable(studentId: student.id),
          ],
        ),
      ),
    );
  }
}
