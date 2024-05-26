import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/screens/academicYear/academicYear_registration.dart';
import 'package:provider/provider.dart';

import '../../constants/appbar_constants.dart';

class AcademicYearScreen extends StatefulWidget {
  const AcademicYearScreen({Key? key});

  static const String academicYearRoute = 'academicYeaar';

  @override
  State<AcademicYearScreen> createState() => _AcademicYearScreenState();
}

class _AcademicYearScreenState extends State<AcademicYearScreen> {
  bool _isLoading = false; // Local loading state in ExamHome

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await context.read<AcademicYearProvider>().fetchAcademicYears();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var academicProvider = Provider.of<AcademicYearProvider>(context);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All Academic Years',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      AcademicYearRegistration.AcademicYearRegistrationRoute);
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : academicProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${academicProvider.error}'),
                  )
                : Consumer<AcademicYearProvider>(
                    builder: (context, academicYearProvider, child) {
                    if (academicYearProvider.academicYears.isEmpty) {
                      // If departments list is empty, fetch data
                      academicYearProvider.fetchAcademicYears();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: academicProvider.academicYears.length,
                        itemBuilder: (context, index) {
                          final academicYear =
                              academicProvider.academicYears[index];
                          return Dismissible(
                            key: Key(academicYear.id.toString()),
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
                                      // Navigator.of(context).pushNamed(
                                      //   NewDepartment.newDepartmentRoute,
                                      //   arguments: department,
                                      // );
                                    }),
                                title: Text('${academicYear.year}'),
                                subtitle: Text('${academicYear.description}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    academicProvider.deleteAcademicYearProvider(
                                        academicYear.id);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }));
  }
}
