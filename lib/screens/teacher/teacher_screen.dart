import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_registration.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';

class TeacherScree extends StatefulWidget {
  const TeacherScree({super.key});
  static const String teacherRoute = 'teacherRoute';
  @override
  State<TeacherScree> createState() => _TeacherScreeState();
}

class _TeacherScreeState extends State<TeacherScree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Teachers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(TeacherRegistration.teacherRegistrationRoute);
              },
              child: const Text(
                'Add new',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: FutureBuilder<List<Teacher>>(
        future: getTeachers(), // Call fetchData() method here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If data is successfully loaded, display the department list
            final List<Teacher>? teachers = snapshot.data;
            return ListView.builder(
              itemCount: teachers?.length ?? 0,
              itemBuilder: (context, index) {
                final teacher = teachers![index];
                return Dismissible(
                  key: Key(teacher.id.toString()),
                  child: Card(
                    child: ListTile(
                      leading: IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber[400],
                          onPressed: () {
                            // Navigator.of(context).pushNamed(
                            //     NewDepartment.newDepartmentRoute,
                            //     arguments: teacher);
                          }),
                      title: Text('${teacher.firstname} ${teacher.lastname}'),
                      subtitle: Text(teacher.phone.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red[900],
                        onPressed: () {
                          deleteTeacher(teacher.id);
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
