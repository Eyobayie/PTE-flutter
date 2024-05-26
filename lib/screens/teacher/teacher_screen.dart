import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/teacher.dart';
import 'package:parent_teacher_engagement_app/screens/teacher/teacher_registration.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';

import '../../constants/appbar_constants.dart';
import '../../constants/card_constants.dart';
import '../../constants/scaffold_constants.dart';

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
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All teachers',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
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
                    elevation: CardConstants.elevationHeight,
                    margin: CardConstants.marginSize,
                    color: CardConstants.backgroundColor,
                    shape: CardConstants.rectangular,
                    child: ListTile(
                      leading: IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber[400],
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                TeacherRegistration.teacherRegistrationRoute,
                                arguments: teacher);
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
