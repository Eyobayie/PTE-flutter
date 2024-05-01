import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/services/gradelevel/gradelevel.dart';

class NewGradeLevel extends StatefulWidget {
  const NewGradeLevel({super.key});
  static const String newgradelevelRoute = 'newGradelevels';
  @override
  State<NewGradeLevel> createState() => _NewGradeLevelState();
}

class _NewGradeLevelState extends State<NewGradeLevel> {
  late final String grade;
  late final String description;
  final _gradeFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final gradeController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    createGradelevel(grade, description);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              shrinkWrap: true, 
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Grade level",
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
                  focusNode: _gradeFocusNode,
                  maxLines: 1,
                  controller: gradeController,
                  onSaved: (value) {
                    grade = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Grade desc",
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
                    description = value!;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveForm,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "Create",
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
      ),
    );
  }
}
