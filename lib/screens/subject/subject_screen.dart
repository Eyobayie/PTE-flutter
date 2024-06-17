import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/screens/subject/subject_registration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/appbar_constants.dart';
import '../../constants/card_constants.dart';
import '../../constants/scaffold_constants.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key});

  static const String subjectRoute = 'subjectRoute';

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
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
      await context.read<SubjectProvider>().fetchSubjects();
    } finally {
      setState(() {
        _isLoading =
            false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var deptProvider = Provider.of<SubjectProvider>(context);

    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All Subjects',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
        actions: [
          if(role=="admin")
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(SubjectRegistration.SubjectRegistrationRoute);
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : deptProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${deptProvider.error}'),
                  )
                : Consumer<SubjectProvider>(
                    builder: (context, departmentProvider, child) {
                    if (departmentProvider.subjects.isEmpty) {
                      // If departments list is empty, fetch data
                      departmentProvider.fetchSubjects();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: deptProvider.subjects.length,
                        itemBuilder: (context, index) {
                          final subject = deptProvider.subjects[index];
                          return Dismissible(
                            key: Key(subject.id.toString()),
                            child: Card(
                              elevation: CardConstants.elevationHeight,
                              margin: CardConstants.marginSize,
                              color: CardConstants.backgroundColor,
                              shape: CardConstants.rectangular,
                              child: ListTile(
                                leading: role == "admin"
                                    ? IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: Colors.amber[400],
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            SubjectRegistration
                                                .SubjectRegistrationRoute,
                                            arguments: subject,
                                          );
                                        })
                                    : null,
                                title: Text(subject.name ?? ''),
                                subtitle: Text(subject.description ?? ''),
                                trailing: role == "admin"
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red[900],
                                        onPressed: () {
                                          deptProvider.deleteSubjectProvider(
                                              subject.id);
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }));
  }
}
