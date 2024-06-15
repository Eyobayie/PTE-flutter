import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_registration.dart';
import 'package:provider/provider.dart';
import 'package:parent_teacher_engagement_app/screens/department/new_department.dart';

import '../../constants/appbar_constants.dart';

class SemisterListScreen extends StatefulWidget {
  const SemisterListScreen({Key? key});

  static const String semisterRoute = 'semisterroutes';

  @override
  State<SemisterListScreen> createState() => _SemisterListScreenState();
}

class _SemisterListScreenState extends State<SemisterListScreen> {
  bool _isLoading = false; // Local loading state in ExamHome

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading =
            true; // Set local isLoading to true before making the API call
      });
      // Use the provider to fetch data
      await context.read<SemisterProvider>().fetchSemisters();
    } finally {
      setState(() {
        _isLoading =
            false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var semiProvider = Provider.of<SemisterProvider>(context);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All Semisters',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(NewSmister.newSemisterRoute);
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
            : semiProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${semiProvider.error}'),
                  )
                : Consumer<SemisterProvider>(
                    builder: (context, semisterProvider, child) {
                    if (semisterProvider.semisters.isEmpty) {
                      // If departments list is empty, fetch data
                      semisterProvider.fetchSemisters();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: semiProvider.semisters.length,
                        itemBuilder: (context, index) {
                          final semister = semiProvider.semisters[index];
                          return Dismissible(
                            key: Key(semister.id.toString()),
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
                                        NewDepartment.newDepartmentRoute,
                                        arguments: semister,
                                      );
                                    }),
                                title: Text(semister.name),
                                subtitle: Text(semister.description ?? ''),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    semiProvider.deleteSemisterProvider(
                                        semister.id);
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
