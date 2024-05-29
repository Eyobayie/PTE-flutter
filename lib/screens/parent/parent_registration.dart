import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/providers/ParentProvider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

import '../../constants/appbar_constants.dart';
import '../../constants/scaffold_constants.dart';

class ParentRegistration extends StatefulWidget {
  const ParentRegistration({super.key});
  static const String ParentRegistrationRoute = "ParentRegistrationRoute";
  @override
  State<ParentRegistration> createState() => _ParentRegistrationState();
}

class _ParentRegistrationState extends State<ParentRegistration> {
  Parent? parent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Parent) {
      parent = args;
      _firstnameController.text = parent?.firstname ?? '';
      _lastnameController.text = parent?.lastname ?? '';
      _emailController.text = parent!.email ?? '';
      _phoneController.text = parent!.phone.toString();
    }
  }

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
  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    final String enteredName = _firstnameController.text.trim();
    final String enteredLstname = _lastnameController.text.trim();
    final String enteredEmail = _emailController.text.trim();
    if (parent == null) {
      try {
        await Provider.of<ParentProvider>(context, listen: false)
            .createParentProvider(
                enteredName, enteredLstname, enteredEmail, _phone);
      } catch (error) {
        print('Error creating department');
      }
    } else {
      try {
        await Provider.of<ParentProvider>(context, listen: false)
            .updateParentProvider(
                parent!.id, enteredName, enteredLstname, enteredEmail, _phone);
      } catch (error) {
        print('Error updating parent: $error');
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          parent == null ? 'parent registration' : 'Edit parent info',
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
              const SizedBox(
                width: 60,
                height: 40,
              ),
              SharedButton(
                onPressed: () => saveForm(),
                text: parent == null ? 'Submit' : 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
