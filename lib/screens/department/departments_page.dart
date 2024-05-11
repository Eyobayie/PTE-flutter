import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/department.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:parent_teacher_engagement_app/services/department/department.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});
  static const String departmentRoute = 'department';
  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Departments",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NewDepartment()));
              },
              child: const Text(
                'Add new',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: FutureBuilder<List<Department>>(
        future: getDepartments(), // Call fetchData() method here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If data is successfully loaded, display the department list
            final List<Department>? departments = snapshot.data;
            return ListView.builder(
              itemCount: departments?.length ?? 0,
              itemBuilder: (context, index) {
                final department = departments![index];
                return Dismissible(
                  key: Key(department.id.toString()),
                  child: Card(
                    child: ListTile(
                      leading: IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber[400],
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                NewDepartment.newDepartmentRoute,
                                arguments: department);
                          }),
                      title: Text(department.name),
                      subtitle: Text(department.description ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red[900],
                        onPressed: () {
                          deleteDepartment(department.id);
                        },
                      ),
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
