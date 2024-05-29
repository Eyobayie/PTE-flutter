import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

import '../../constants/scaffold_constants.dart';
import '../../models/department.dart';

class NewDepartment extends StatefulWidget {
  const NewDepartment({super.key});
  static const String newDepartmentRoute = 'newDepartment';

  @override
  State<NewDepartment> createState() => _NewDepartmentState();
}

class _NewDepartmentState extends State<NewDepartment> {
  String name = '';
  String description = '';
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Department? department;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Department) {
      department = args;
      nameController.text = department?.name ?? '';
      descriptionController.text = department?.description ?? '';
    }
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredName = nameController.text.trim();
    final String enteredDescription = descriptionController.text.trim();

    if (department == null) {
      // Create new department
      try {
        await Provider.of<DepartmentProvider>(context, listen: false)
            .createDepartmentProvider(enteredName, enteredDescription);
      } catch (error) {
        print('Error creating department: $error');
      }
    } else {
      // Update existing department
      try {
        await Provider.of<DepartmentProvider>(context, listen: false)
            .updateDepartmentProvider(
                department!.id, enteredName, enteredDescription);
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
          department == null ? 'Add new department' : 'Edit department',
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
                      labelText: "Department name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Department name is required';
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
                      labelText: "Department description",
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
                    text: department == null ? 'CREATE' : 'UPDATE',
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
