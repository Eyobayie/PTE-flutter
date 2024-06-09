import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/models/semister_model.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';

import 'package:provider/provider.dart';

import '../../constants/scaffold_constants.dart';
import '../../models/department.dart';

class NewSmister extends StatefulWidget {
  const NewSmister({super.key});
  static const String newSemisterRoute = 'newSemister';

  @override
  State<NewSmister> createState() => _NewSmisterState();
}

class _NewSmisterState extends State<NewSmister> {
  String name = '';
  String description = '';

  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Semister? semister;

  int? _selectedAcademicYearId;

  @override
  void initState() {
    super.initState();
    Provider.of<AcademicYearProvider>(context, listen: false)
        .fetchAcademicYears();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Semister) {
      semister = args;
      nameController.text = semister?.name ?? '';
      descriptionController.text = semister?.description ?? '';
      _selectedAcademicYearId = semister?.AcademicYearId;
    }
  }

  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();

    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedAcademicYearId == null) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredName = nameController.text.trim();
    final String enteredDescription = descriptionController.text.trim();
    if (semister == null) {
      // Create new semester
      try {
        await Provider.of<SemisterProvider>(context, listen: false)
            .createSemisterProvider(
                enteredName, enteredDescription, _selectedAcademicYearId!);
      } catch (error) {
        print('Error creating semester: $error');
      }
    } else {
      // Update existing semester
      try {
        await Provider.of<SemisterProvider>(context, listen: false)
            .updateSemisterProvider(semister!.id, enteredName,
                enteredDescription, _selectedAcademicYearId!);
      } catch (error) {
        print('Error updating semester: $error');
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
          semister == null ? 'Add new Semister' : 'Edit Semister',
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
                      labelText: "Semister name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Semister name is required';
                      }
                      return null;
                    },
                    focusNode: _nameFocusNode,
                    controller: nameController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      name = value ?? '';
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Semister description",
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
                  const SizedBox(height: 10),
                  Consumer<AcademicYearProvider>(
                    builder: (context, academicYearProvider, child) {
                      if (academicYearProvider.academicYears.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Academic Year",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: academicYearProvider.academicYears
                            .map((academicYear) {
                          return DropdownMenuItem<int>(
                            value: academicYear.id,
                            child: Text(academicYear.year.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAcademicYearId = value;
                          });
                        },
                        value: _selectedAcademicYearId,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an academic year';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  SharedButton(
                    onPressed: saveForm,
                    text: semister == null ? 'CREATE' : 'UPDATE',
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
