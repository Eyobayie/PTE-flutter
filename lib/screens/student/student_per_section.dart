import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/providers/AttendanceProvider.dart';
import 'package:parent_teacher_engagement_app/services/student/student.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:provider/provider.dart';

class StudentPerSection extends StatefulWidget {
  const StudentPerSection({Key? key}) : super(key: key);

  static const String studentRoute = 'studentRoute';

  @override
  State<StudentPerSection> createState() => _StudentPerSectionState();
}

class _StudentPerSectionState extends State<StudentPerSection> {
  late int gradelevelId;
  late int sectionId;
  final bool isPresent = false;
  @override
  void initState() {
    super.initState();
    // Fetch arguments directly in initState if they are passed immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        setState(() {
          gradelevelId = args['gradelevelId'];
          sectionId = args['sectionId'];
        });
      }
    });
  }

  Future<List<Student>> getStudentPerSectionWithLogging(
      int gradelevelId, int sectionId) async {
    try {
      final students = await getStudentPerSection(gradelevelId, sectionId);
      return students;
    } catch (e) {
      print('Error fetching students: $e');
      rethrow;
    }
  }

  void saveAttendance(int studentId, bool isPresent) {
    DateTime date = DateTime.now();
    int teacherId = 1;

    if (studentId != null && teacherId != null) {
      Provider.of<AttendanceProvider>(context, listen: false)
          .addAttendance(studentId, studentId, date, teacherId, isPresent)
          .then((_) {})
          .catchError((error) {
        print('Error creating attendance: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Section students',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(NewDepartment.newDepartmentRoute);
            },
            child: const Text(
              'Add new',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: gradelevelId != null && sectionId != null
            ? getStudentPerSectionWithLogging(gradelevelId, sectionId)
            : Future.value([]), // Return an empty list or handle loading state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Student> students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Dismissible(
                  key: Key(student.id.toString()),
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
                            NewDepartment.newDepartmentRoute,
                            arguments: student,
                          );
                        },
                      ),
                      title: Text(student.firstname),
                      subtitle: Text(student.phone.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 20,
                            ),
                            color: AppBarConstants.backgroundColor,
                            onPressed: () {
                              // View button action
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              saveAttendance(student.id, true);
                              print('${student.firstname} is Present');
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green, // text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text('Present'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              saveAttendance(student.id, false);
                              print('${student.firstname} is Absent');
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red, // text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text('Absent'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
