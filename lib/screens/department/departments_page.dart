// import 'package:flutter/material.dart';
// import 'package:parent_teacher_engagement_app/models/department.dart';
// import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
// import 'package:parent_teacher_engagement_app/services/department/department.dart';

// class DepartmentPage extends StatefulWidget {
//   const DepartmentPage({super.key});
//   static const String departmentRoute = 'department';
//   @override
//   State<DepartmentPage> createState() => _DepartmentPageState();
// }

// class _DepartmentPageState extends State<DepartmentPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "All Departments",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const NewDepartment()));
//               },
//               child: const Text(
//                 'Add new',
//                 style: TextStyle(color: Colors.white),
//               ))
//         ],
//       ),
//       body: FutureBuilder<List<Department>>(
//         future: getDepartments(), // Call fetchData() method here
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // While waiting for data to load, show a loading indicator
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             // If an error occurs, display an error message
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             // If data is successfully loaded, display the department list
//             final List<Department>? departments = snapshot.data;
//             return ListView.builder(
//               itemCount: departments?.length ?? 0,
//               itemBuilder: (context, index) {
//                 final department = departments![index];
//                 return Dismissible(
//                   key: Key(department.id.toString()),
//                   child: Card(
//                     child: ListTile(
//                       leading: IconButton(
//                           icon: const Icon(Icons.edit),
//                           color: Colors.amber[400],
//                           onPressed: () {
//                             Navigator.of(context).pushNamed(
//                                 NewDepartment.newDepartmentRoute,
//                                 arguments: department);
//                           }),
//                       title: Text(department.name),
//                       subtitle: Text(department.description ?? ''),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         color: Colors.red[900],
//                         onPressed: () {
//                           deleteDepartment(department.id);
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:provider/provider.dart';
import 'package:parent_teacher_engagement_app/models/department.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';

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
            "All Departments",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewDepartment(),
                ));
              },
              child: const Text(
                'Add new',
                style: TextStyle(color: Colors.white),
              ),
            )
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
                :
                // Consumer<DepartmentProvider>(
                //     builder: (context, departmentProvider, child) {
                //       if (departmentProvider.departments.isEmpty) {
                //         // If departments list is empty, fetch data
                //         departmentProvider.fetchDepartments();
                //         return const Center(child: CircularProgressIndicator());
                //       } else {
                //         If departments list is not empty, display the department list
                //         return
                ListView.builder(
                    itemCount: deptProvider.departments.length,
                    itemBuilder: (context, index) {
                      final department = deptProvider.departments[index];
                      return Dismissible(
                        key: Key(department.id.toString()),
                        child: Card(
                          child: ListTile(
                            leading: IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.amber[400],
                                // onPressed: () {
                                //   Navigator.of(context).pushNamed(
                                //     NewDepartment.newDepartmentRoute,
                                //     arguments: department,
                                //   );
                                // },
                                onPressed: () {
                                  if (department.id != null) {
                                    Navigator.of(context).pushNamed(
                                      NewDepartment.newDepartmentRoute,
                                      arguments: department,
                                    );
                                  } else {
                                    // Handle the case where id is null
                                  }
                                }),
                            title: Text(department.name),
                            subtitle: Text(department.description ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red[900],
                              // onPressed: () {
                              //   departmentProvider
                              //       .deleteDepartmentProvider(department.id);
                              // },
                              onPressed: () {
                                if (department.id != null) {
                                  deptProvider
                                      .deleteDepartmentProvider(department.id);
                                } else {
                                  // Handle the case where id is null
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  )
        //}
        // },
        // ),
        );
  }
}
