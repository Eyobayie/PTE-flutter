import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/assinTeacher_provider.dart';
import 'package:parent_teacher_engagement_app/screens/assign_teacher/newAssign_teacher.dart';
import 'package:provider/provider.dart';

class AssignTeacher extends StatefulWidget {
  const AssignTeacher({super.key});
  static const String assignTeacherRoute = 'assignTeacherRoute';

  @override
  State<AssignTeacher> createState() => _AssignTeacherState();
}

class _AssignTeacherState extends State<AssignTeacher> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<AssignTeacherProvider>().fetchAssignedTeachers();
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Assigned Teacher ',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(NewTeacherAssignment.newTeacherAssignmentRoute);
            },
            child: const Text(
              'Add new',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<AssignTeacherProvider>(
              builder: (context, teacherAssignProvider, child) {
                if (teacherAssignProvider.error.isNotEmpty) {
                  return Center(
                    child: Text('Error: ${teacherAssignProvider.error}'),
                  );
                }

                if (teacherAssignProvider.assignedTeachers.isEmpty) {
                  return const Center(
                    child: Text('No assigned teachers found.'),
                  );
                }

                return ListView.builder(
                  itemCount: teacherAssignProvider.assignedTeachers.length,
                  itemBuilder: (context, index) {
                    final assignedTeacher =
                        teacherAssignProvider.assignedTeachers[index];
                    return Dismissible(
                      key: Key(assignedTeacher.id.toString()),
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
                                NewTeacherAssignment.newTeacherAssignmentRoute,
                                arguments: assignedTeacher,
                              );
                            },
                          ),
                          title: Text(
                            'Academic Year: ${assignedTeacher.AcademicYearId}',
                          ),
                          subtitle: Text(
                            'Section: ${assignedTeacher.SectionId}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red[900],
                            onPressed: () {
                              teacherAssignProvider
                                  .removeAssignedTeacher(assignedTeacher.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
