import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
import 'package:parent_teacher_engagement_app/services/gradelevel/gradelevel.dart';

import '../../constants/scaffold_constants.dart';

class GradeDetailScreen extends StatelessWidget {
  final Gradelevel gradelevel;
  static const String gradeDetailScreenRoute = 'gradeDetailScreenRoute';
  const GradeDetailScreen({Key? key, required this.gradelevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          gradelevel.grade,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                CreateSection.createSectionRoute,
                arguments: gradelevel.id,
              );
            },
            child: const Text(
              'Add Section',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Gradelevel>(
          future: fetchGradeWithSections(gradelevel.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Gradelevel grade = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text('Sections:'),
                  Column(
                    children: grade.sections.map((section) {
                      return Card(
                        child: ListTile(
                          title: Text(section.name),
                          subtitle: Text(section.description ?? ''),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
