import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/helpResponseProvider.dart';
import 'package:parent_teacher_engagement_app/screens/help/help_Dialog.dart';
import 'package:provider/provider.dart';

import '../../constants/appbar_constants.dart';

class HelpResponsePage extends StatefulWidget {
  const HelpResponsePage({Key? key});

  static const String helpRoute = 'help';

  @override
  State<HelpResponsePage> createState() => _HelpResponsePageState();
}

class _HelpResponsePageState extends State<HelpResponsePage> {
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

      await context.read<HelpResponseProvider>().fetchHelps();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var helpProvider = Provider.of<HelpResponseProvider>(context);

    return Scaffold(
        backgroundColor: ScaffoldConstants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'All Help Request',
            style: AppBarConstants.textStyle,
          ),
          backgroundColor: AppBarConstants.backgroundColor,
          iconTheme: AppBarConstants.iconTheme,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : helpProvider.error.isNotEmpty
                ? Center(
                    child: Text('Error: ${helpProvider.error}'),
                  )
                : Consumer<HelpResponseProvider>(
                    builder: (context, HelppProvider, child) {
                    if (HelppProvider.helps.isEmpty) {
                      HelppProvider.fetchHelps();
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: helpProvider.helps.length,
                        itemBuilder: (context, index) {
                          final department = helpProvider.helps[index];
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(department.date);
                          return Dismissible(
                            key: Key(department.id.toString()),
                            child: Card(
                              elevation: CardConstants.elevationHeight,
                              margin: CardConstants.marginSize,
                              color: CardConstants.backgroundColor,
                              shape: CardConstants.rectangular,
                              child: ListTile(
                                title: Text(department.description),
                                subtitle: Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.remove_red_eye,
                                    size: 15,
                                  ),
                                  color: AppBarConstants.iconThem,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => HelpDialog(
                                            ParentId: department.ParentId),
                                      ),
                                    );
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
