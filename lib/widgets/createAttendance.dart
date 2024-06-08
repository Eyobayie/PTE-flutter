import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/providers/AttendanceProvider.dart';
import 'package:parent_teacher_engagement_app/services/student/student.dart';
import 'package:provider/provider.dart';

class NewAttendancePage extends StatefulWidget {
  const NewAttendancePage({
    Key? key,
  }) : super(key: key);

  static const String newAttendance = 'newAttendanceRoute';

  @override
  State<NewAttendancePage> createState() => _NewAttendancePageState();
}

class _NewAttendancePageState extends State<NewAttendancePage> {
  late int gradelevelId;
  late int sectionId;
  final Map<int, bool> attendanceStatus = {};
  final _startTimeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        setState(() {
          gradelevelId = args['GradelevelId'];
          sectionId = args['SectionId'];
        });
        fetchAndInitializeAttendanceStatus();
      }
    });
  }

  Future<void> fetchAndInitializeAttendanceStatus() async {
    try {
      final students =
          await getStudentPerSectionWithLogging(gradelevelId, sectionId);
      setState(() {
        attendanceStatus.clear();
        for (var student in students) {
          attendanceStatus[student.id] = false;
        }
      });
    } catch (e) {
      print('Error initializing attendance status: $e');
    }
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

  void saveAttendance(List<Map<String, dynamic>> attendanceList) {
    Provider.of<AttendanceProvider>(context, listen: false)
        .addBulkAttendance(attendanceList)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance submitted successfully')),
      );
    }).catchError((error) {
      print('Error creating attendance: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting attendance: $error')),
      );
    });
  }

  void submitAttendance() {
    List<Map<String, dynamic>> attendanceList =
        attendanceStatus.entries.map((entry) {
      int studentId = entry.key;
      bool isPresent = entry.value;
      return {
        "date": _startTimeController.text,
        "isPresent": isPresent,
        "StudentId": studentId,
        "TeacherId": 1
      };
    }).toList();
    print('Attendance is : $attendanceList');
    saveAttendance(attendanceList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
            onPressed: submitAttendance,
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: CardConstants.backgroundColor,
            width: 150,
            child: TextFormField(
              readOnly: true,
              controller: _startTimeController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                hintText: 'Select Date',
                hintStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onTap: () {
                _selectStartTime(context);
              },
              maxLines: 1,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<List<Student>>(
            future: gradelevelId != null && sectionId != null
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
                // Initialize attendanceStatus for the fetched students
                for (var student in students) {
                  attendanceStatus.putIfAbsent(student.id, () => false);
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: CardConstants.backgroundColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dataRowHeight: 50, // Adjust the row height as needed
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Parent Name')),
                          DataColumn(label: Text('Is Present')),
                        ],
                        rows: students.map((student) {
                          return DataRow(cells: [
                            DataCell(Text(student.firstname)),
                            DataCell(Text(student.parent?.firstname ?? '')),
                            DataCell(
                              Checkbox(
                                value: attendanceStatus[student.id] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    attendanceStatus[student.id] =
                                        value ?? false;
                                  });
                                },
                              ),
                            ),
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
        ],
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8,
            child: child,
          );
        });
    if (pickedDate != null) {
      setState(() {
        _startTimeController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
