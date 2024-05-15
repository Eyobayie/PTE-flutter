import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
import 'package:parent_teacher_engagement_app/services/gradelevel/gradelevel.dart';

class GradeDetailScreen extends StatefulWidget {
  const GradeDetailScreen({super.key});
  static const String gradeDetailScreenRoute = 'gradeDetailScreenRoute';
  @override
  State<GradeDetailScreen> createState() => _GradeDetailScreenState();
}

class _GradeDetailScreenState extends State<GradeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gradelevel details',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CreateSection.createSectionRoute, arguments: id);
              },
              child: const Text(
                'Add Section',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: FutureBuilder<Gradelevel>(
          future: fetchGradeWithSections(id),
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
                  Text('Grade: ${grade.grade}'),
                  Text('Description: ${grade.description}'),
                  const SizedBox(height: 20),
                  const Text('Sections:'),
                  Column(
                    children: grade.sections.map((section) {
                      return ListTile(
                        title: Text(section.name),
                        subtitle: Text(section.description ?? ''),
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
