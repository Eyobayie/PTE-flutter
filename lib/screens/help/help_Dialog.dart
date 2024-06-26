import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/helpProvider.dart';
import 'package:provider/provider.dart';

class HelpDialog extends StatefulWidget {
  int? ParentId;

  HelpDialog({super.key, this.ParentId});

  static const String helpDialogRoute = 'helpDialog';

  @override
  State<HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  final _descriptionFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? description;
  late int parentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final parentProvider =
          Provider.of<ParentProvider>(context, listen: false);
      await parentProvider.fetchParents();
      parentId = parentProvider
          .parents.first.id; // Assuming you want the first parent's ID
      print('parentId: $parentId');

      if (parentId != null) {
        await Provider.of<HelpProvider>(context, listen: false)
            .getHelpsWithResponsesByParentId(widget.ParentId);
      }
    });
  }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    description = descriptionController.text.trim();
    final DateTime date = DateTime.now();

    if (description != null && description!.isNotEmpty && parentId != null) {
      Provider.of<HelpProvider>(context, listen: false)
          .createHelpProvider(description!, date, parentId)
          .then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        print('Error creating help: $error');
      });
      descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppBarConstants.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Help Center',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome To PTE, We are here to assist you with any issues that you have faced.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer<HelpProvider>(
                        builder: (context, helpProvider, child) {
                          if (helpProvider.helps.isEmpty) {
                            return const Center(
                              child: Text(
                                'No messages yet...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: helpProvider.helps.length,
                              itemBuilder: (context, index) {
                                final help = helpProvider.helps[index];
                                final formattedDate =
                                    DateFormat('yyyy-MM-dd').format(help.date);
                                return ChatBubble(
                                  message: help.description,
                                  date: formattedDate,
                                  isMe: true,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Form(
                          key: _formKey,
                          child: Expanded(
                            child: TextFormField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: 'questions',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                      color: AppBarConstants.iconThem),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'question is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_descriptionFocusNode);
                              },
                              focusNode: _descriptionFocusNode,
                              maxLines: null,
                              onSaved: (value) {
                                description = value!;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: AppBarConstants.backgroundColor,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: saveForm,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String date;
  final bool isMe;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.date,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                date,
                style: const TextStyle(color: Colors.black54, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
// import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
// import 'package:parent_teacher_engagement_app/providers/helpProvider.dart';
// import 'package:provider/provider.dart';

// class HelpDialog extends StatefulWidget {
//   const HelpDialog({super.key});

//   @override
//   State<HelpDialog> createState() => _HelpDialogState();
// }

// class _HelpDialogState extends State<HelpDialog> {
//   final _descriptionFocusNode = FocusNode();
//   final descriptionController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? description;
//   late int parentId;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final parentProvider = Provider.of<ParentProvider>(context, listen: false);
//       await parentProvider.fetchParents();
//       parentId = parentProvider.parents.first.id; // Assuming you want the first parent's ID
//       print('parentId: $parentId');

//       if (parentId != null) {
//         await Provider.of<HelpProvider>(context, listen: false).getHelpsWithResponsesByParentId(parentId);
//       }
//     });
//   }

//   void saveForm() {
//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     _formKey.currentState!.save();

//     description = descriptionController.text.trim();
//     final DateTime date = DateTime.now();

//     if (description != null && description!.isNotEmpty && parentId != null) {
//       Provider.of<HelpProvider>(context, listen: false)
//           .createHelpProvider(description!, date, parentId)
//           .then((_) {
//         Navigator.pop(context);
//       }).catchError((error) {
//         print('Error creating help: $error');
//       });
//       descriptionController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: SizedBox(
//         height: 400,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: AppBarConstants.backgroundColor,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//               ),
//               child: const Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.person, color: Colors.blue),
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     'Help Center',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.grey[200],
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Welcome To PTE, We are here to assist you with any issues that you have faced.',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Expanded(
//                       child: Consumer<HelpProvider>(
//                         builder: (context, helpProvider, child) {
//                           if (helpProvider.helps.isEmpty) {
//                             return const Center(
//                               child: Text(
//                                 'No messages yet...',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             );
//                           } else {
//                             return ListView.builder(
//                               itemCount: helpProvider.helps.length,
//                               itemBuilder: (context, index) {
//                                 final help = helpProvider.helps[index];
//                                 final formattedDate = DateFormat('yyyy-MM-dd').format(help.date);

//                                 List<Widget> chatWidgets = [];

//                                 chatWidgets.add(
//                                   ChatBubble(
//                                     message: help.description,
//                                     date: formattedDate,
//                                     isMe: true,
//                                   ),
//                                 );

//                                 for (var response in help.helpResponses) {
//                                   chatWidgets.add(
//                                     ChatBubble(
//                                       message: response.description,
//                                       date: DateFormat('yyyy-MM-dd').format(response.date),
//                                       isMe: false,
//                                     ),
//                                   );
//                                 }

//                                 return Column(children: chatWidgets);
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Form(
//                           key: _formKey,
//                           child: Expanded(
//                             child: TextFormField(
//                               controller: descriptionController,
//                               decoration: InputDecoration(
//                                 hintText: 'questions',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(50),
//                                   borderSide: BorderSide(color: AppBarConstants.iconThem),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'question is required';
//                                 }
//                                 return null;
//                               },
//                               onFieldSubmitted: (value) {
//                                 FocusScope.of(context).requestFocus(_descriptionFocusNode);
//                               },
//                               focusNode: _descriptionFocusNode,
//                               maxLines: null,
//                               onSaved: (value) {
//                                 description = value!;
//                               },
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         CircleAvatar(
//                           backgroundColor: AppBarConstants.backgroundColor,
//                           child: IconButton(
//                             icon: const Icon(Icons.send, color: Colors.white),
//                             onPressed: saveForm,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final String date;
//   final bool isMe;

//   const ChatBubble({
//     Key? key,
//     required this.message,
//     required this.date,
//     required this.isMe,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blue[200] : Colors.grey[300],
//           borderRadius: isMe
//               ? const BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                   bottomLeft: Radius.circular(15),
//                 )
//               : const BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                   bottomRight: Radius.circular(15),
//                 ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               message,
//               style: const TextStyle(color: Colors.black),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Text(
//                 date,
//                 style: const TextStyle(color: Colors.black54, fontSize: 10),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
