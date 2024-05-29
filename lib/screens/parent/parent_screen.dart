import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_registration.dart';
import 'package:parent_teacher_engagement_app/services/parent/parent.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';

import '../../constants/appbar_constants.dart';
import '../../constants/scaffold_constants.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});
  static const String parentRoute = 'parentrRoute';
  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All parents',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ParentRegistration.ParentRegistrationRoute);
              },
              child: const Text(
                'Add new',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: FutureBuilder<List<Parent>>(
        future: getParents(), // Call fetchData() method here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If data is successfully loaded, display the department list
            final List<Parent>? parents = snapshot.data;
            return ListView.builder(
              itemCount: parents?.length ?? 0,
              itemBuilder: (context, index) {
                final parent = parents![index];
                return Card(
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
                              ParentRegistration.ParentRegistrationRoute,
                              arguments: parent);
                        }),
                    title: Text('${parent.firstname} ${parent.lastname}'),
                    subtitle: Text(parent.phone.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red[900],
                      onPressed: () {
                        deleteTeacher(parent.id);
                      },
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
