import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:parent_teacher_engagement_app/providers/AttendanceProvider.dart';
import 'package:provider/provider.dart';

class AttendanceWidget extends StatefulWidget {
  final int studentId;

  const AttendanceWidget({Key? key, required this.studentId}) : super(key: key);

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await context
          .read<AttendanceProvider>()
          .fetchAttendances(widget.studentId);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var attendProvider = Provider.of<AttendanceProvider>(context);
    final columnWidth = MediaQuery.of(context).size.width * 0.33;
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : attendProvider.error.isNotEmpty
              ? Center(
                  child: Text('Error: ${attendProvider.error}'),
                )
              : Consumer<AttendanceProvider>(
                  builder: (context, attendanceProvider, child) {
                    if (attendanceProvider.attendances.isEmpty) {
                      return const Center(child: Text('No Attendance Records'));
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Table(
                            defaultColumnWidth: FixedColumnWidth(columnWidth),
                            border: TableBorder.all(
                                color: const Color.fromARGB(255, 66, 61, 61),
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              const TableRow(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 94, 3, 110)),
                                  children: [
                                    Column(children: [
                                      Text('Date',
                                          style: TextStyle(fontSize: 16.0))
                                    ]),
                                    Column(children: [
                                      Text('Present',
                                          style: TextStyle(fontSize: 16.0))
                                    ]),
                                    Column(children: [
                                      Text('Actions',
                                          style: TextStyle(fontSize: 16.0))
                                    ]),
                                  ]),
                              ...attendanceProvider.attendances
                                  .map((attendance) {
                                final formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(attendance.date); // Format the date
                                return TableRow(children: [
                                  Column(children: [
                                    Text(formattedDate)
                                  ]), // Display formatted date
                                  Column(children: [
                                    attendance.isPresent
                                        ? const Icon(Icons.done)
                                        : const Icon(Icons.remove)
                                  ]),
                                  Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.edit),
                                            color: Colors.amber[400],
                                            onPressed: () {
                                              // Edit action
                                            }),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red[900],
                                          onPressed: () {
                                            // Delete action
                                          },
                                        ),
                                      ],
                                    )
                                  ]),
                                ]);
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
    );
  }
}
