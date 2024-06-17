import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/providers/AttendanceProvider.dart';
import 'package:parent_teacher_engagement_app/screens/Assignment/assignment_screen.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_detail.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_registration.dart';
import 'package:parent_teacher_engagement_app/services/student/student.dart';
import 'package:parent_teacher_engagement_app/widgets/createAttendance.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int? id;
  String? role;

  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data including role
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

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      role = prefs.getString('role');
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
          .addAttendance(studentId, date, teacherId, isPresent)
          .then((_) {})
          .catchError((error) {
        print('Error creating attendance: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      gradelevelId = args['gradelevelId'] ?? 0;
      sectionId = args['sectionId'] ?? 0;
    } else {
      // Provide default values if args are null
      gradelevelId = 0;
      sectionId = 0;
    }

    return role == 'teacher' || role == 'admin'
        ? Scaffold(
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
                  child: PopupMenuItem(
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showMenu(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: Colors.white),
                          ),
                          color: Colors.white,
                          context: context,
                          position: const RelativeRect.fromLTRB(82, 82, 0, 0),
                          items: [
                            if (role == "admin")
                              PopupMenuItem(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      StudentRegistration
                                          .StudentRegistrationRoute);
                                },
                                value: 1,
                                child: const Text('Add New'),
                              ),
                            if (role == 'teacher' || role == 'admin')
                              PopupMenuItem(
                                onTap: () async {
                                  Navigator.of(context).pushNamed(
                                      AssignmentScreen.assignmentRoute,
                                      arguments: gradelevelId);
                                },
                                value: 2,
                                child: const Text('Assignments'),
                              ),
                            if (role == 'teacher' || role == 'admin')
                              PopupMenuItem(
                                onTap: () async {
                                  Navigator.of(context).pushNamed(
                                      NewAttendancePage.newAttendance,
                                      arguments: {
                                        'SectionId': sectionId,
                                        'GradelevelId': gradelevelId
                                      });
                                },
                                value: 3,
                                child: const Text('Attendance'),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            body: FutureBuilder<List<Student>>(
              future: gradelevelId != 0 && sectionId != 0
                  ? getStudentPerSectionWithLogging(gradelevelId, sectionId)
                  : Future.value(
                      []), // Return an empty list or handle loading state
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      color: CardConstants.backgroundColor,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          dataRowHeight: 50, // Adjust the row height as needed
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Fa.name')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: students.map((student) {
                            return DataRow(cells: [
                              DataCell(Text(student.firstname ?? '')),
                              DataCell(Text(student.parent?.firstname ?? '')),
                              DataCell(Text(student.phone.toString())),
                              DataCell(IconButton(
                                icon: const Icon(Icons.remove_red_eye_outlined),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      StudentDetailScreen.studentDetailRoute,
                                      arguments: student);
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Your students',
                style: AppBarConstants.textStyle,
              ),
              backgroundColor: AppBarConstants.backgroundColor,
              centerTitle: true,
            ),
            body: FutureBuilder<List<Student>>(
              future: id != null
                  ? getStudentsByParentId(id, sectionId)
                  : Future.value(
                      []), // Return an empty list or handle loading state
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    color: Color(0xff87BAD7),
                    child: AlertDialog(
                      title: const Text('Access Denied!!!',style: TextStyle(color: Colors.red, fontSize: 30),),
                      content: Container(
                        width: 150.0, // Set the desired width
                        height: 100.0, // Set the desired height
                        child: const SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text("You haven't the privilege to access it."),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<Student> students = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      color: CardConstants.backgroundColor,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          dataRowHeight: 50, // Adjust the row height as needed
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Fa.name')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: students.map((student) {
                            return DataRow(cells: [
                              DataCell(Text(student.firstname ?? '')),
                              DataCell(Text(student.parent?.firstname ?? '')),
                              DataCell(Text(student.phone.toString())),
                              DataCell(IconButton(
                                icon: const Icon(Icons.remove_red_eye_outlined),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      StudentDetailScreen.studentDetailRoute,
                                      arguments: student);
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
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

  Future<dynamic> _showDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to delete this result percentage?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
