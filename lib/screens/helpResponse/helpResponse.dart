// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
// import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
// import 'package:parent_teacher_engagement_app/providers/helpResponseProvider.dart';
// import 'package:parent_teacher_engagement_app/screens/help/help_Dialog.dart';
// import 'package:provider/provider.dart';

// import '../../constants/appbar_constants.dart';

// class HelpResponsePage extends StatefulWidget {
//   const HelpResponsePage({Key? key});

//   static const String helpRoute = 'help';

//   @override
//   State<HelpResponsePage> createState() => _HelpResponsePageState();
// }

// class _HelpResponsePageState extends State<HelpResponsePage> {
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       await context.read<HelpResponseProvider>().fetchHelps();
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var helpProvider = Provider.of<HelpResponseProvider>(context);

//     return Scaffold(
//         backgroundColor: ScaffoldConstants.backgroundColor,
//         appBar: AppBar(
//           title: const Text(
//             'All Help Request',
//             style: AppBarConstants.textStyle,
//           ),
//           backgroundColor: AppBarConstants.backgroundColor,
//           iconTheme: AppBarConstants.iconTheme,
//         ),
//         body: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : helpProvider.error.isNotEmpty
//                 ? Center(
//                     child: Text('Error: ${helpProvider.error}'),
//                   )
//                 : Consumer<HelpResponseProvider>(
//                     builder: (context, HelppProvider, child) {
//                     if (HelppProvider.helps.isEmpty) {
//                       HelppProvider.fetchHelps();
//                       return const Center(child: CircularProgressIndicator());
//                     } else {
//                       return ListView.builder(
//                         itemCount: helpProvider.helps.length,
//                         itemBuilder: (context, index) {
//                           final department = helpProvider.helps[index];
//                           final formattedDate =
//                               DateFormat('yyyy-MM-dd').format(department.date);
//                           return Dismissible(
//                             key: Key(department.id.toString()),
//                             child: Card(
//                               elevation: CardConstants.elevationHeight,
//                               margin: CardConstants.marginSize,
//                               color: CardConstants.backgroundColor,
//                               shape: CardConstants.rectangular,
//                               child: ListTile(
//                                 title: Text(department.description),
//                                 subtitle: Text(
//                                   formattedDate,
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey),
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(
//                                         Icons.replay_outlined,
//                                         size: 20,
//                                       ),
//                                       color: AppBarConstants.backgroundColor,
//                                       onPressed: () {

//                                       },
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(
//                                         Icons.remove_red_eye_outlined,
//                                         // remove_red_eye_outlined,
//                                         size: 20,
//                                       ),
//                                       color: AppBarConstants.backgroundColor,
//                                       onPressed: () {
//                                         // View button action
//                                       },
//                                     ),
//                                     // ElevatedButton(
//                                     //   onPressed: () {
//                                     //     // saveAttendance(student.id, true);
//                                     //     print('is Present');
//                                     //   },
//                                     //   style: ElevatedButton.styleFrom(
//                                     //     foregroundColor: Colors.white,
//                                     //     backgroundColor:
//                                     //         Colors.green, // text color
//                                     //     shape: RoundedRectangleBorder(
//                                     //       borderRadius:
//                                     //           BorderRadius.circular(5),
//                                     //     ),
//                                     //   ),
//                                     //   child: const Text('Replay'),
//                                     // ),
//                                   ],
//                                 ),
//                                 //  IconButton(
//                                 //   icon: const Icon(
//                                 //     Icons.remove_red_eye,
//                                 //     size: 15,
//                                 //   ),
//                                 //   color: AppBarConstants.iconThem,
//                                 //   onPressed: () {
//                                 //     Navigator.of(context).push(
//                                 //       MaterialPageRoute(
//                                 //         builder: (context) => HelpDialog(
//                                 //             ParentId: department.ParentId),
//                                 //       ),
//                                 //     );
//                                 //   },
//                                 // ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   }));
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/helpResponseProvider.dart';
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

  Future<void> showTextInputDialog(
      BuildContext context, String description) async {
    TextEditingController _textController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reply to: $description',
            style: TextStyle(fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: "Enter your reply"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Icon(Icons.send),
              onPressed: () {
                // Implement your send logic here using _textController.text
                print('Reply: ${_textController.text}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.replay_outlined,
                                        size: 20,
                                      ),
                                      color: AppBarConstants.backgroundColor,
                                      onPressed: () {
                                        showTextInputDialog(
                                            context, department.description);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20,
                                      ),
                                      color: AppBarConstants.backgroundColor,
                                      onPressed: () {
                                        // View button action
                                      },
                                    ),
                                  ],
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
