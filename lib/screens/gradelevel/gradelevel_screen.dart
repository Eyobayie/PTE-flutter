import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradeDetail.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/new_grade.dart';
import 'package:parent_teacher_engagement_app/services/gradelevel/gradelevel.dart';

class GradelevelScreen extends StatefulWidget {
  const GradelevelScreen({super.key});
  static const String gradelevelScreenRoute = "gradelevelRoute";
  @override
  State<GradelevelScreen> createState() => _GradelevelScreenState();
}

class _GradelevelScreenState extends State<GradelevelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Grade levels",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(NewGradeLevel.newgradelevelRoute);
              },
              child: const Text(
                'Add new',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: FutureBuilder<List<Gradelevel>>(
        future: getGradelevels(), // Call fetchData() method here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data to load, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If data is successfully loaded, display the gradelevel list
            final List<Gradelevel>? gradelevels = snapshot.data;
            return ListView.builder(
              itemCount: gradelevels?.length ?? 0,
              itemBuilder: (context, index) {
                final gradelevel = gradelevels![index];
                return Dismissible(
                  key: Key(gradelevel.id.toString()),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            GradeDetailScreen.gradeDetailScreenRoute,
                            arguments: gradelevel.id);
                      },
                      leading: IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber[400],
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                NewGradeLevel.newgradelevelRoute,
                                arguments: gradelevel);
                          }),
                      title: Text(gradelevel.grade),
                      subtitle: Text(gradelevel.description ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red[900],
                        onPressed: () {
                          deleteGradelevel(gradelevel.id);
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
