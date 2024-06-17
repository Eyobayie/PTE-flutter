import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/models/announcement.dart';
import 'package:parent_teacher_engagement_app/providers/AnnouncemetProvider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

import '../../constants/scaffold_constants.dart';

class AnnouncementForm extends StatefulWidget {
  const AnnouncementForm({super.key});
  static const String AnnouncementFormRoute = 'AnnouncementForm';

  @override
  State<AnnouncementForm> createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Announcement? announcement;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Announcement) {
      announcement = args;
      titleController.text = announcement?.title ?? '';
      descriptionController.text = announcement?.description ?? '';
    }
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredTitle = titleController.text.trim();
    final String enteredDescription = descriptionController.text.trim();

    if (announcement == null) {
      // Create new department
      try {
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .createAnnouncementProvider(date, enteredTitle, enteredDescription);
      } catch (error) {
        print('Error creating announcement: $error');
      }
    } else {
      // Update existing department
      try {
        await Provider.of<AnnouncementProvider>(context, listen: false)
            .updateAnnouncementProvider(
                announcement!.id, date, enteredTitle, enteredDescription);
      } catch (error) {
        print('Error updating department: $error');
      }
    }

    Navigator.of(context).pop(); // Pop the create/update page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          announcement == null ? 'Add new Announcement' : 'Edit Announcement',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0),
        child: Card(
          elevation: CardConstants.elevationHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 70),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                    focusNode: _titleFocusNode,
                    controller: titleController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      title = value ?? '';
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    focusNode: _descriptionFocusNode,
                    maxLines: 4,
                    controller: descriptionController,
                    onSaved: (value) {
                      description = value ?? '';
                    },
                  ),
                  const SizedBox(height: 40),
                  SharedButton(
                    onPressed: saveForm,
                    text: announcement == null ? 'CREATE' : 'UPDATE',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
