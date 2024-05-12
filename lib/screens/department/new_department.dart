import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/services/department/department.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

class NewDepartment extends StatefulWidget {
  const NewDepartment({super.key});
  static const String newDepartmentRoute = 'newDepartment';

  @override
  State<NewDepartment> createState() => _NewDepartmentState();
}

class _NewDepartmentState extends State<NewDepartment> {
  //late final String name;
  String name = ''; // Remove the `late` keyword
  String description = '';
  //late final String description;
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // void saveForm() {
  //   final isValid = _formKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   // createDepartment(name, description);
  //   // Navigator.pop(context);
  //   if (name.isEmpty || description.isEmpty) {
  //     return;
  //   }
  //   createDepartment(name, description).then((createdDepartment) {
  //     Provider.of<DepartmentProvider>(context, listen: false)
  //         .addDepartment(createdDepartment);
  //     //Navigator.pop(context);
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => const NewDepartment(),
  //     ));
  //   }).catchError((error) {
  //     print('Error creating department: $error');
  //   });
  // }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final String? enteredName = nameController.text.trim();
    final String? enteredDescription = descriptionController.text.trim();

    if (enteredName == null || enteredDescription == null) {
      return;
    }

    Provider.of<DepartmentProvider>(context, listen: false)
        .createDepartmentProvider(enteredName, enteredDescription)
        .then((_) {
      Navigator.of(context).pop(); // Pop the create page
    }).catchError((error) {
      print('Error creating department from new department page: $error');
      // Handle error here
    });
  }

  @override
  Widget build(BuildContext context) {
    // final department = ModalRoute.of(context)!.settings.arguments as Department;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add new department',
          style: TextStyle(color: Color(0xFFC5A364)),
        ),
        backgroundColor: Color(0xFF1D1B20),
        iconTheme: IconThemeData(
            color: Color(0xFFC5A364)), // Set the color for the back button
      ),
      body:
          // Center(
          //   child:
          Padding(
        padding:
            const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0), // Add top padding
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true, // ensure ListView takes only the space it needs
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
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _nameFocusNode,
                maxLines: 1,
                controller: nameController,
                onSaved: (value) {
                  //name = value!;
                  name = value ?? '';
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Department desc",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                focusNode: _descriptionFocusNode,
                maxLines: 4,
                controller: descriptionController,
                onSaved: (value) {
                  //description = value!;
                  description = value ?? '';
                },
              ),
              SizedBox(height: 20),
              SharedButton(
                onPressed: saveForm,
                text: 'CREATE',
              ),
            ],
          ),
        ),
      ),
      //),
    );
  }
}
