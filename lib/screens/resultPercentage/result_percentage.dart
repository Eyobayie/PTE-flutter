import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/providers/resultPercentageProvider.dart';
import 'package:parent_teacher_engagement_app/screens/resultPercentage/add_result_percentage.dart';
import 'package:provider/provider.dart';

class ResultPercentageScreen extends StatefulWidget {
  const ResultPercentageScreen({Key? key}) : super(key: key);
  static const resultPercentageRoute = 'resultPercentage-list';

  @override
  _ResultPercentageScreenState createState() =>
      _ResultPercentageScreenState();
}

class _ResultPercentageScreenState extends State<ResultPercentageScreen> {
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
      await context.read<ResultPercentageProvider>().fetchResultPercentages();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ResultPercentageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Percentages', style: AppBarConstants.textStyle,),
        backgroundColor: AppBarConstants.backgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error.isNotEmpty
              ? Center(child: Text('Error: ${provider.error}'))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: CardConstants.backgroundColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Percentage')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: provider.resultPercentages.map((resultPercentage) {
                        return DataRow(cells: [
                          DataCell(Text(resultPercentage.name ?? '')),
                          DataCell(Text('${resultPercentage.percentage}%')),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to edit screen
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete this result percentage?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            provider.deleteResultPercentageProvider(
                                                resultPercentage.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create screen
          Navigator.of(context).pushNamed(NewResultPercentageForm.newResultParcentageRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
