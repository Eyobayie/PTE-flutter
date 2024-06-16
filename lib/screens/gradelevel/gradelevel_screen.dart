import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/gradeDetail.dart';
import 'package:parent_teacher_engagement_app/screens/gradelevel/new_grade.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/scaffold_constants.dart';

class GradelevelScreen extends StatefulWidget {
  const GradelevelScreen({Key? key});
  static const String gradelevelScreenRoute = "gradelevelRoute";
  @override
  State<GradelevelScreen> createState() => _GradelevelScreenState();
}

class _GradelevelScreenState extends State<GradelevelScreen> {
  bool _isLoading = false; // Local loading state in ExamHome
  int? id;
  String? role;

  @override
  void initState() {
    super.initState();
    fetchData();
    getUserData();
  }
 Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id');
      role = prefs.getString('role');
    });
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
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ALL Grades',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
        actions: [
         if(role=="admin")
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
                        return GestureDetector(
                          onTap: () {
                            _showGradeDetailBottomSheet(context, gradelevel);
                          },
                          child: Card(
                            elevation: CardConstants.elevationHeight,
                            margin: CardConstants.marginSize,
                            color: CardConstants.backgroundColor,
                            shape: CardConstants.rectangular,
                            child: ListTile(
                              leading:role=="admin"? IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.amber[400],
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    NewGradeLevel.newgradelevelRoute,
                                    arguments: gradelevel,
                                  );
                                },
                              ):null,
                              title: Text(gradelevel.grade),
                              subtitle: Text(gradelevel.description ?? ''),
                              trailing:role=="admin"? IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red[900],
                                onPressed: () {
                                  gradeProvider
                                      .deleteGradelevelProvider(gradelevel.id);
                                },
                              ):null,
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  void _showGradeDetailBottomSheet(
      BuildContext context, Gradelevel gradelevel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the bottom sheet to take up the full height of the screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                20.0)), // Optional: Customize the shape of the bottom sheet
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          child: GradeDetailScreen(gradelevel: gradelevel),
        );
      },
    );
  }
}
