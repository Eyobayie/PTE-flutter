import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/services/teacher/teacher.dart';

import '../../constants/appbar_constants.dart';

class TeacherRegistration extends StatefulWidget {
  const TeacherRegistration({super.key});
  static const String teacherRegistrationRoute = "teacherRegistrationRoute";
  @override
  State<TeacherRegistration> createState() => _TeacherRegistrationState();
}

class _TeacherRegistrationState extends State<TeacherRegistration> {
  // Declaring variables
  late final String _firstname;
  late final String _lastname;
  late final String _email;
  late final int _phone;
//Declaring focus nodes
  final _firstnameFocusNode = FocusNode();
  final _lastnameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  // Declaring controllers
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    registerTeacher(_firstname, _lastname, _email, _phone);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teacher registration',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true, // ensure ListView takes only the space it needs
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "First name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_lastnameFocusNode);
                },
                focusNode: _firstnameFocusNode,
                maxLines: 1,
                controller: _firstnameController,
                onSaved: (value) {
                  _firstname = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                focusNode: _lastnameFocusNode,
                maxLines: 1,
                controller: _lastnameController,
                onSaved: (value) {
                  _lastname = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_phoneFocusNode);
                },
                focusNode: _emailFocusNode,
                maxLines: 1,
                controller: _emailController,
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone numner is required';
                  }
                  return null;
                },
                // onFieldSubmitted: (value) {
                //   FocusScope.of(context).requestFocus();
                // },
                focusNode: _phoneFocusNode,
                maxLines: 1,
                controller: _phoneController,
                onSaved: (value) {
                  _phone = int.tryParse(value!) ?? 0;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 60,
                height: 40,
                child: ElevatedButton(
                  onPressed: saveForm,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
