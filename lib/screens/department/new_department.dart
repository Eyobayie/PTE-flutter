import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/services/department/department.dart';

class NewDepartment extends StatefulWidget {
  const NewDepartment({super.key});
  static const String newDepartmentRoute = 'newDepartment';

  @override
  State<NewDepartment> createState() => _NewDepartmentState();
}

class _NewDepartmentState extends State<NewDepartment> {
  late final String name;
  late final String description;
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    createDepartment(name, description);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // final department = ModalRoute.of(context)!.settings.arguments as Department;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new department'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                    name = value!;
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
                    description = value!;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveForm,
                  child: const Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
