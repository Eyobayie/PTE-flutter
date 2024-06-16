import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/appbar_constants.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({Key? key});

  static const String departmentRoute = 'department';

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  bool _isLoading = false; 
  int? id;
  String? role;
  
  @override
  void initState() {
    super.initState();
    fetchData();
    getUserData();
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
        _isLoading = true; // Set local isLoading to true before making the API call
      });
      // Use the provider to fetch data
      await context.read<DepartmentProvider>().fetchDepartments();
    } finally {
      setState(() {
        _isLoading = false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  Widget sideBar(BuildContext context, String title, Icon icon, String route) {
    return ListTile(
      title: Text(title),
      leading: icon,
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var deptProvider = Provider.of<DepartmentProvider>(context);
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All departments',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          if (role == "admin")
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NewDepartment.newDepartmentRoute);
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
              : Consumer<DepartmentProvider>(
                  builder: (context, departmentProvider, child) {
                    if (departmentProvider.departments.isEmpty) {
                      departmentProvider.fetchDepartments();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: deptProvider.departments.length,
                        itemBuilder: (context, index) {
                          final department = deptProvider.departments[index];
                          return Dismissible(
                            key: Key(department.id.toString()),
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
                                            NewDepartment.newDepartmentRoute,
                                            arguments: department,
                                          );
                                        },
                                      )
                                    : null,
                                title: Text(department.name),
                                subtitle: Text(department.description ?? ''),
                                trailing: role == "admin"
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red[900],
                                        onPressed: () {
                                          deptProvider.deleteDepartmentProvider(department.id);
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
    );
  }
}
