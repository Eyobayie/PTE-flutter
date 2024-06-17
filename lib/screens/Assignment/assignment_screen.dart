import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AssignmentProvider.dart';
import 'package:parent_teacher_engagement_app/screens/Assignment/assignment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/appbar_constants.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key});

  static const String assignmentRoute = 'assignments';

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  bool _isLoading = false; // Local loading state in ExamHome
  int? id;
  String? role;
  @override
  void initState() {
    super.initState();
    getUserData();
    fetchData();
  }
    Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      role = prefs.getString('role');
    });
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading =
            true; // Set local isLoading to true before making the API call
      });
      // Use the provider to fetch data
      await context.read<AssignmentProvider>().fetchAssignments();
    } finally {
      setState(() {
        _isLoading =
            false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var assignProvider = Provider.of<AssignmentProvider>(context);
    final gradelevelId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All assignments',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            if(role=="admin")
            TextButton(
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushNamed(AssignmentPage.assignmentRoute,
                  //      arguments: gradelevelId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AssignmentPage(gradelevelId: gradelevelId),
                    ),
                  );
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
            : assignProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${assignProvider.error}'),
                  )
                : Consumer<AssignmentProvider>(
                    builder: (context, assignmentProvider, child) {
                    if (assignmentProvider.assignments.isEmpty) {
                      // If departments list is empty, fetch data
                      assignmentProvider.fetchAssignments();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: assignProvider.assignments.length,
                        itemBuilder: (context, index) {
                          final assignment = assignProvider.assignments[index];
                          return Dismissible(
                            key: Key(assignment.id.toString()),
                            child: Card(
                              elevation: CardConstants.elevationHeight,
                              margin: CardConstants.marginSize,
                              color: CardConstants.backgroundColor,
                              shape: CardConstants.rectangular,
                              child: ListTile(
                                leading: role=="admin"? IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.amber[400],
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        AssignmentPage.assignmentRoute,
                                        arguments: assignment,
                                      );
                                    }):null,
                                title: Text(assignment.title),
                                subtitle: Text(assignment.description),
                                trailing:role=="admin"? IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    assignProvider
                                        .deleteAssignmentRecord(assignment.id);
                                  },
                                ):null,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }));
  }
}
