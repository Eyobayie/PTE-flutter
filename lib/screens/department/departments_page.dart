import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';

import '../../constants/appbar_constants.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({Key? key});

  static const String departmentRoute = 'department';

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
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
      await context.read<DepartmentProvider>().fetchDepartments();
    } finally {
      setState(() {
        _isLoading =
            false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var deptProvider = Provider.of<DepartmentProvider>(context);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All departments',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(NewDepartment.newDepartmentRoute);
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
            : deptProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${deptProvider.error}'),
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
                        itemCount: deptProvider.departments.length,
                        itemBuilder: (context, index) {
                          final department = deptProvider.departments[index];
                          return Dismissible(
                            key: Key(department.id.toString()),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                leading: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.amber[400],
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        NewDepartment.newDepartmentRoute,
                                        arguments: department,
                                      );
                                    }),
                                title: Text(department.name),
                                subtitle: Text(department.description ?? ''),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    deptProvider.deleteDepartmentProvider(
                                        department.id);
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
