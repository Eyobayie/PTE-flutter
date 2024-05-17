import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradeDetail.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/new_grade.dart';
import 'package:provider/provider.dart';

import '../../constants/appbar_constants.dart';

class GradelevelScreen extends StatefulWidget {
  const GradelevelScreen({super.key});
  static const String gradelevelScreenRoute = "gradelevelRoute";
  @override
  State<GradelevelScreen> createState() => _GradelevelScreenState();
}

class _GradelevelScreenState extends State<GradelevelScreen> {
  bool _isLoading = false; // Local loading state in ExamHome

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final gradeProvider = context.read<GradelevelProvider>();
    try {
      setState(() {
        _isLoading = true;
      });
      await gradeProvider.fetchGradelevels();
    } catch (e) {
      gradeProvider.setError('Error fetching gradelevels: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradelevelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ALL Grades',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(NewGradeLevel.newgradelevelRoute);
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
          : gradeProvider.error.isNotEmpty
              ? Center(
                  child: Text('Error: ${gradeProvider.error}'),
                )
              : gradeProvider.gradelevels.isEmpty
                  ? const Center(child: Text('No gradelevels found'))
                  : ListView.builder(
                      itemCount: gradeProvider.gradelevels.length,
                      itemBuilder: (context, index) {
                        final gradelevel = gradeProvider.gradelevels[index];
                        return Dismissible(
                          key: Key(gradelevel.id.toString()),
                          child: Card(
                            elevation: 1,
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
                                    NewDepartment.newDepartmentRoute,
                                    arguments: gradelevel,
                                  );
                                },
                              ),
                              title: Text(gradelevel.grade),
                              subtitle: Text(gradelevel.description ?? ''),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red[900],
                                onPressed: () {
                                  gradeProvider
                                      .deleteGradelevelProvider(gradelevel.id);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
