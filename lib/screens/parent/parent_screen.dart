import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
import 'package:parent_teacher_engagement_app/screens/parent/parent_registration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/appbar_constants.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key});

  static const String parentRoute = 'parent';

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
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
    try {
      setState(() {
        _isLoading =
            true; // Set local isLoading to true before making the API call
      });
      // Use the provider to fetch data
      await context.read<ParentProvider>().fetchParents();
    } finally {
      setState(() {
        _isLoading =
            false; // Set local isLoading to false after the API call is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var parentProvider = Provider.of<ParentProvider>(context);
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
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
            if(role=="admin")
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : parentProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${parentProvider.error}'),
                  )
                : Consumer<ParentProvider>(
                    builder: (context, departmentProvider, child) {
                    if (departmentProvider.parents.isEmpty) {
                      // If departments list is empty, fetch data
                      departmentProvider.fetchParents();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      // If departments list is not empty, display the department list
                      return ListView.builder(
                        itemCount: parentProvider.parents.length,
                        itemBuilder: (context, index) {
                          final parent = parentProvider.parents[index];
                          return Dismissible(
                            key: Key(parent.id.toString()),
                            child: Card(
                              elevation: CardConstants.elevationHeight,
                              margin: CardConstants.marginSize,
                              color: CardConstants.backgroundColor,
                              shape: CardConstants.rectangular,
                              child: ListTile(
                                leading: role=="admin"? IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.amber[400],
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        ParentRegistration
                                            .ParentRegistrationRoute,
                                        arguments: parent,
                                      );
                                    }):null,
                                title: Text(parent.firstname),
                                subtitle: Text('${parent.phone}'),
                                trailing: role=="admin"? IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    parentProvider
                                        .deleteParentProvider(parent.id);
                                  },
                                ):null,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }));
  }
}
