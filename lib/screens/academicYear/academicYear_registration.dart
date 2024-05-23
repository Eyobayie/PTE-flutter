import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

import '../../constants/scaffold_constants.dart';

class AcademicYearRegistration extends StatefulWidget {
  const AcademicYearRegistration({super.key});
  static const String AcademicYearRegistrationRoute =
      'AcademicYearRegistration';

  @override
  State<AcademicYearRegistration> createState() =>
      _AcademicYearRegistrationState();
}

class _AcademicYearRegistrationState extends State<AcademicYearRegistration> {
  //late final String name;
  late int year; // Remove the `late` keyword
  late String description;
  //late final String description;
  final _yearFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final yearController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final int? enteredYear = int.tryParse(yearController.text.trim());
    final String enteredDescription = descriptionController.text.trim();

    if (enteredYear == null) {
      return;
    }

    Provider.of<AcademicYearProvider>(context, listen: false)
        .createAcademicYearProvider(enteredYear, enteredDescription)
        .then((_) {
      Navigator.of(context).pop(); // Pop the create page
    }).catchError((error) {
      print('Error creating academic year from new department page: $error');
      // Handle error here
    });
  }

  @override
  Widget build(BuildContext context) {
    // final department = ModalRoute.of(context)!.settings.arguments as Department;
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add new Academic year',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
      ),
      body: Padding(
          padding:
              const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0), // Add top padding
          child: Card(
            elevation: CardConstants.elevationHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 70),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap:
                      true, // ensure ListView takes only the space it needs
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Academic year",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          )),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Academic year is required';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      focusNode: _yearFocusNode,
                      maxLines: 1,
                      controller: yearController,
                      onSaved: (value) {
                        //name = value!;
                        year = int.tryParse(value ?? '')!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Academic year description...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      controller: descriptionController,
                      onSaved: (value) {
                        //description = value!;
                        description = value ?? '';
                      },
                    ),
                    const SizedBox(height: 40),
                    SharedButton(
                      onPressed: saveForm,
                      text: 'CREATE',
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
