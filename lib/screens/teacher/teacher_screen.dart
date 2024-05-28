import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/TeacherProvider.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_registration.dart';
import 'package:provider/provider.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';

import '../../constants/appbar_constants.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key});

  static const String teacherRoute = 'teacher';

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  bool _isLoading = false; // Local loading state in ExamHome

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading =
            true; // Set local isLoading to true before making the API call
      });
      // Use the provider to fetch data
      await context.read<TeacherProvider>().fetchTeachers();
    } finally {
      setState(() {
        _isLoading =
            false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var teachProvider = Provider.of<TeacherProvider>(context);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All Teachers',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(TeacherRegistration.teacherRegistrationRoute);
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : teachProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${teachProvider.error}'),
                  )
                : Consumer<DepartmentProvider>(
                    builder: (context, departmentProvider, child) {
                    if (departmentProvider.departments.isEmpty) {
                      // If departments list is empty, fetch data
                      departmentProvider.fetchDepartments();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: teachProvider.teachers.length,
                        itemBuilder: (context, index) {
                          final teacher = teachProvider.teachers[index];
                          return Dismissible(
                            key: Key(teacher.id.toString()),
                            child: Card(
                              elevation: CardConstants.elevationHeight,
                              margin: CardConstants.marginSize,
                              color: CardConstants.backgroundColor,
                              shape: CardConstants.rectangular,
                              child: ListTile(
                                leading: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.amber[400],
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        TeacherRegistration
                                            .teacherRegistrationRoute,
                                        arguments: teacher,
                                      );
                                    }),
                                title: Text('${teacher.firstname} +'
                                    '+ ${teacher.lastname}'),
                                subtitle: Text('${teacher.phone}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    teachProvider
                                        .deleteTeacherProvider(teacher.id);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }));
  }
}
