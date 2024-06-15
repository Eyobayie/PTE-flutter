import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/services/studentResult/student_result.dart';
import 'package:parent_teacher_engagement_app/models/student_result.dart';

class ResultTable extends StatefulWidget {
  final int studentId;
  ResultTable({required this.studentId});
  @override
  _ResultTableState createState() => _ResultTableState();
}

class _ResultTableState extends State<ResultTable> {
  late Future<List<StudentResult>> futureResults;

  @override
  void initState() {
    super.initState();
    futureResults = fetchStudentResults(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<List<StudentResult>>(
          future: futureResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Print the error for debugging
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Print the snapshot data for debugging
              print('Data: ${snapshot.data}');
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Result')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Year')),
                    DataColumn(label: Text('Semester')),
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Student')),
                    DataColumn(label: Text('Percentage')),
                  ],
                  rows: snapshot.data!.map((result) {
                    return DataRow(cells: [
                     DataCell(Text(result.result.toString())),
                      DataCell(Text(result.resultType ?? 'N/A')),
                      DataCell(Text(result.academicYear?.year.toString() ?? 'N/A')),
                      DataCell(Text(result.semister?.name ?? 'N/A')),
                      DataCell(Text(result.subject?.name ?? 'N/A')),
                      DataCell(Text(result.student?.firstname ?? 'N/A')),
                      DataCell(Text(result.resultPercentage?.percentage?.toString() ?? 'N/A')),
                    ]);
                  }).toList(),
                ),
              );
             } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
    );
  }
}
