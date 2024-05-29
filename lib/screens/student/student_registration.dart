import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/models/section.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/providers/StudentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SectionProvider.dart';
import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

import '../../constants/appbar_constants.dart';
import '../../constants/scaffold_constants.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});
  static const String StudentRegistrationRoute = 'StudentRegistration';

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  String firstname = '';
  String? email;
  int? phone;
  int? GradelevelId;
  int? SectionId;
  int? ParentId;

  final firstnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<GradelevelProvider>(context, listen: false).fetchGradelevels();
    Provider.of<ParentProvider>(context, listen: false).fetchParents();
  }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid ||
        GradelevelId == null ||
        SectionId == null ||
        ParentId == null) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredName = firstnameController.text.trim();
    final String enteredEmail = emailController.text.trim();
    final int? enteredPhone = int.tryParse(phoneController.text.trim());

    if (enteredPhone == null) {
      print('Invalid phone number');
      return;
    }

    Provider.of<StudentProvider>(context, listen: false)
        .createStudentProvider(enteredName, enteredEmail, enteredPhone,
            SectionId!, GradelevelId!, ParentId!)
        .then((_) {
      Navigator.of(context).pop();
      print("grade levelID...+ $GradelevelId");
      print("grade levelID...+ $ParentId");
      print("grade levelID...+ $SectionId");
      print("grade levelID...+ $enteredName");
      print("grade levelID...+ $enteredPhone");
      print("grade levelID...+ $enteredEmail");
    }).catchError((error) {
      print('Error creating student: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Add new student', style: AppBarConstants.textStyle),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
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
                    labelText: "Student name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    )),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Student name is required';
                  }
                  return null;
                },
                maxLines: 1,
                controller: firstnameController,
                onSaved: (value) {
                  firstname = value ?? '';
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                maxLines: 1,
                controller: emailController,
                onSaved: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                maxLines: 1,
                controller: phoneController,
                onSaved: (value) {
                  phone = int.tryParse(value ?? '');
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
                        GradelevelId = value;
                        Provider.of<SectionProvider>(context, listen: false)
                            .fetchSections(GradelevelId);
                        SectionId =
                            null; // Reset section when grade level changes
                      });
                    },
                    value: GradelevelId,
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
              Consumer<SectionProvider>(
                builder: (context, sectionProvider, child) {
                  if (GradelevelId == null ||
                      sectionProvider.sections.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Section",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    items: sectionProvider.sections.map((Section section) {
                      return DropdownMenuItem<int>(
                        value: section.id,
                        child: Text(section.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        SectionId = value;
                      });
                    },
                    value: SectionId,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a section';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer<ParentProvider>(
                builder: (context, parentProvider, child) {
                  if (parentProvider.parents.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Parent",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    items: parentProvider.parents.map((Parent parent) {
                      return DropdownMenuItem<int>(
                        value: parent.id,
                        child: Text(parent.firstname),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        ParentId = value;
                      });
                    },
                    value: ParentId,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a parent';
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
