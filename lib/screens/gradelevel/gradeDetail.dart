import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/screens/section/create_section.dart';
import 'package:parent_teacher_engagement_app/screens/student/student_per_section.dart';
import 'package:parent_teacher_engagement_app/services/gradelevel/gradelevel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/scaffold_constants.dart';

class GradeDetailScreen extends StatefulWidget {
  final Gradelevel gradelevel;
  static const String gradeDetailScreenRoute = 'gradeDetailScreenRoute';
  const GradeDetailScreen({Key? key, required this.gradelevel})
      : super(key: key);

  @override
  State<GradeDetailScreen> createState() => _GradeDetailScreenState();
}

class _GradeDetailScreenState extends State<GradeDetailScreen> {
  int? id;
  String? role;

  @override
  void initState() {
    super.initState();
    getUserData();
  }
   Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      role = prefs.getString('role');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.gradelevel.grade,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          if(role=="admin")
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                CreateSection.createSectionRoute,
                arguments: widget.gradelevel.id,
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
          future: fetchGradeWithSections(widget.gradelevel.id),
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
                    children: grade.sections!.map((section) {
                      return Card(
                        color: CardConstants.backgroundColor,
                        elevation: CardConstants.elevationHeight,
                        margin: CardConstants.marginSize,
                        shape: CardConstants.rectangular,
                        child: ListTile(
                          title: Text(section.name),
                          subtitle: Text(section.description ?? ''),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                StudentPerSection.studentRoute,
                                arguments: {
                                  'gradelevelId': widget.gradelevel.id,
                                  'sectionId': section.id
                                },
                              );
                            },
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            iconSize: 20,
                            color: AppBarConstants.backgroundColor,
                          ),
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
