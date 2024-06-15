import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/screens/semister/semister_registration.dart';
import 'package:provider/provider.dart';

class SemisterListScreen extends StatefulWidget {
  SemisterListScreen({super.key, Key});
  static const String semisterRoute = 'semisterRoute';

  @override
  State<SemisterListScreen> createState() => _SemisterListScreenState();
}

class _SemisterListScreenState extends State<SemisterListScreen> {
  bool _isLoading = false;
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

      await context.read<SemisterProvider>().fetchSemisters();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var semiProvider = Provider.of<SemisterProvider>(context);

    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Semisters',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(NewSmister.newSemisterRoute);
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
                      semisterProvider.fetchSemisters();
                      return const Center(child: CircularProgressIndicator());
                    } else {
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
                                        NewSmister.newSemisterRoute,
                                        arguments: semister,
                                      );
                                    }),
                                title: Text(semister.name?? ''),
                                subtitle: Text(semister.description ?? ''),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red[900],
                                  onPressed: () {
                                    semiProvider
                                        .deleteSemisterProvider(semister.id?? 0);
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
