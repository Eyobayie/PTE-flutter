import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/services/section/section.dart';

import '../../constants/scaffold_constants.dart';

class CreateSection extends StatefulWidget {
  const CreateSection({super.key});
  static const createSectionRoute = 'createSectionRoute';
  @override
  State<CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<CreateSection> {
  late final String _name;
  late final String _description;
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final int gradelevelId;
  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    createSection(_name, _description, gradelevelId);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gradelevelId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add new gradelevels',
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
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Section",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Grade level is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _nameFocusNode,
                maxLines: 1,
                controller: _nameController,
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Desctiption",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                focusNode: _descriptionFocusNode,
                maxLines: 4,
                controller: _descriptionController,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: saveForm,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.orange,
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
