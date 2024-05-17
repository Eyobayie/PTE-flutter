import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

class SubjectRegistration extends StatefulWidget {
  const SubjectRegistration({super.key});
  static const String SubjectRegistrationRoute = 'SubjectRegistration';

  @override
  State<SubjectRegistration> createState() => _SubjectRegistrationState();
}

class _SubjectRegistrationState extends State<SubjectRegistration> {
  String name = '';
  String? description;
  int? gradelevelId;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<GradelevelProvider>(context, listen: false).fetchGradelevels();
  }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || gradelevelId == null) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredName = nameController.text.trim();
    final String enteredDescription = descriptionController.text.trim();

    Provider.of<SubjectProvider>(context, listen: false)
        .createSubjectProvider(enteredName, enteredDescription, gradelevelId!)
        .then((_) {
      Navigator.of(context).pop(); // Pop the create page
    }).catchError((error) {
      print('Error creating subject: $error');
      // Handle error here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add new subject',
          style: TextStyle(color: Color(0xFFC5A364)),
        ),
        backgroundColor: const Color(0xFF1D1B20),
        iconTheme: const IconThemeData(
            color: Color(0xFFC5A364)), // Set the color for the back button
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Subject name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    )),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Subject name is required';
                  }
                  return null;
                },
                maxLines: 1,
                controller: nameController,
                onSaved: (value) {
                  name = value ?? '';
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Subject description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                maxLines: 4,
                controller: descriptionController,
                onSaved: (value) {
                  description = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              Consumer<GradelevelProvider>(
                builder: (context, gradelevelProvider, child) {
                  if (gradelevelProvider.gradelevels.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Grade level",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    items: gradelevelProvider.gradelevels
                        .map((Gradelevel gradelevel) {
                      return DropdownMenuItem<int>(
                        value: gradelevel.id,
                        child: Text(gradelevel.grade),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        gradelevelId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a grade level';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              SharedButton(
                onPressed: saveForm,
                text: 'CREATE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
