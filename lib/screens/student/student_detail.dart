import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/widgets/attendance.dart';

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key});
  static const studentDetailRoute = 'studentDetail';

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          student.firstname,
          style: AppBarConstants.textStyle,
        ),
        actions: [
          TextButton(
              onPressed: () {},
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
            Tab(text: 'Details'),
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
            const Center(child: Text('Here is the detail')),
            AttendanceWidget(studentId: student.id),
            const Center(child: Text('Here is the performance')),
          ],
        ),
      ),
    );
  }
}
